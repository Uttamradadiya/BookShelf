var configData = config;
var identityPoolId = configData.IdentityPoolId;
var apiGatewayURL = configData.APIInvokeURL;
var lambdaFunctionName = configData.LambdaFunctionGetName;
var awsRegion = configData.AwsRegion;
var logoutURL = configData.LogoutUrl;

document.querySelector(".sign-out-button").onclick = function () {
  location.href = logoutURL;
};

AWS.config.region = awsRegion;
AWS.config.credentials = new AWS.CognitoIdentityCredentials({
  IdentityPoolId: identityPoolId
});

var lambda = new AWS.Lambda();

function formatUploadTime(uploadTime) {
  const date = new Date(uploadTime);
  return date.toLocaleString(); 
}

function listProducts() {
  console.log('listProducts() function called');
  var params = {
    FunctionName: lambdaFunctionName,
    InvocationType: 'RequestResponse',
    LogType: 'None'
  };

  lambda.invoke(params, function (err, data) {
    if (err) {
      console.log('Error invoking Lambda:', err);
    } else {
      console.log('Lambda response:', data);
      var response = JSON.parse(data.Payload);
      var productData = JSON.parse(response.body);
      var productList = document.getElementById("productList");
      productList.innerHTML = "";

      if (productData.length === 0) {
        var message = document.createElement("p");
        message.innerText = "Oops! No products to show :(";
        message.className = "message";
        productList.appendChild(message);
        return;
      }

      for (var i = 0; i < productData.length; i++) {
        var card = document.createElement("div");
        card.className = "card";

        var presignedURL = productData[i].presigned_url;
        var uploadTime = productData[i].upload_time;

        var thumbnailDiv = document.createElement("div");
        thumbnailDiv.className = "thumbnail";
        thumbnailDiv.style.backgroundImage = `url(${presignedURL})`;
        thumbnailDiv.style.backgroundSize = "cover"; 
    
        var cardBody = document.createElement("div");
        cardBody.className = "card-body";

        var cardTitle = document.createElement("h5");
        cardTitle.className = "card-title";
        var productTitle = productData[i]['product-name'];
        cardTitle.innerText = "Product Name: " + productTitle;

        var time = document.createElement("p");
        time.innerText = "Upload Time: " + formatUploadTime(uploadTime);

        var price = document.createElement("p");
        price.innerText = "Price: " + productData[i]['product-price'];

        var shortDescription = document.createElement("p");
        shortDescription.innerText = "Short Description: " + productData[i]['product-short-title'];

        cardBody.appendChild(cardTitle);
        cardBody.appendChild(time);
        cardBody.appendChild(price);
        cardBody.appendChild(shortDescription);
        card.appendChild(thumbnailDiv);
        card.appendChild(cardBody);
        productList.appendChild(card);
        
        card.classList.add("column");
      }
    }
  });
}


function uploadProduct() {
  const fileInput = document.getElementById("fileInput");
  const productName = document.getElementById("productName").value;
  const productPrice = document.getElementById("productPrice").value;
  const productShortTitle = document.getElementById("productShortTitle").value;

  const file = fileInput.files[0];

  const fileName = file.name;

  fetch(apiGatewayURL + `?file_name=${encodeURIComponent(fileName)}&product_name=${encodeURIComponent(productName)}&product_price=${encodeURIComponent(productPrice)}&product_short_title=${encodeURIComponent(productShortTitle)}`)
      .then(response => {
          if (response.ok) {
              return response.json();
          } else {
              throw new Error("Failed to get presigned URL: " + response.status);
          }
      })
      .then(data => {
          const presignedUrl = data.presigned_url;

          return fetch(presignedUrl, {
              method: "PUT",
              headers: {
                  "Content-Type": file.type
              },
              body: file
          });
      })
      .then(response => {
          if (response.ok) {
              console.log("File uploaded successfully!");

              storeProductDetailsDynamoDB(productName, productPrice, productShortTitle, fileName);

              alert("File uploaded successfully!");
              window.location.href = "index.html";
          } else {
              throw new Error("Failed to upload file: " + response.status);
          }
      })
      .catch(error => {
          console.error(error);
          alert("Error: " + error.message);
      });
}

function storeProductDetailsDynamoDB(productName, productPrice, productShortTitle, fileName) {
  fetch(apiGatewayURL, {
      method: "POST",
      headers: {
          "Content-Type": "application/json"
      },
      body: JSON.stringify({
          product_name: productName,
          product_price: productPrice,
          product_short_title: productShortTitle,
          file_name: fileName
      })
  })
  .then(response => response.json())
  .then(data => {
      console.log("Product details stored in DynamoDB:", data);
  })
  .catch(error => {
      console.error("Error storing product details in DynamoDB:", error);
  });
}

window.onload = listProducts;
