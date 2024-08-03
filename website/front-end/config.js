var config = {
  APIInvokeURL: "https://eqwtfjtnd0.execute-api.eu-central-1.amazonaws.com/devl/{proxy+}?file_name=",
  IdentityPoolId: "eu-central-1:e27f2666-d91a-44a4-94cc-c235fe14492f",
  LambdaFunctionGetName: "bookshelf_get_object",
  AwsRegion: "eu-central-1",
  LogoutUrl: "https://bookstore-du.auth.eu-central-1.amazoncognito.com/logout?response_type=code&client_id=78k24gqfb07hho1ts0ejmou8vp&redirect_uri=https://bookshelf-webhost-bucket1.s3.eu-central-1.amazonaws.com/bookshelf/index.html"
};

module.exports = config;
