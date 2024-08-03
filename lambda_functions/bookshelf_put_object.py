import json
import boto3
from datetime import datetime 

def lambda_handler(event, context):
    s3 = boto3.client("s3")
    dynamodb = boto3.client("dynamodb")
    table_name = "bookshelf-product-data"

    file_name = event["queryStringParameters"]["file_name"]
    product_name = event["queryStringParameters"]["product_name"] 
    product_price = event["queryStringParameters"]["product_price"] 
    product_short_title = event["queryStringParameters"]["product_short_title"]  

    bucket_name = "bookshelf-bucket1"

    try:
        # Generate a presigned URL for upload product
        presigned_url = s3.generate_presigned_url(
            ClientMethod="put_object",
            Params={"Bucket": bucket_name, "Key": file_name},
            ExpiresIn=3600
        )

        # Store the product details and current date and time in DynamoDB
        upload_time = datetime.now().isoformat()
        response = dynamodb.put_item(
            TableName=table_name,
            Item={
                "product-title": {"S": file_name},
                "upload-time": {"S": upload_time},
                "product-name": {"S": product_name},  
                "product-price": {"N": str(product_price)},  
                "product-short-title": {"S": product_short_title}              }
        )

        # Return the presigned URL to the client
        response = {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST"
            },
            "body": json.dumps({"presigned_url": presigned_url})
        }
        return response
    except Exception as e:
        # Return an error response
        response = {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST"
            },
            "body": json.dumps("Failed to generate presigned URL and store filename: " + str(e))
        }
        return response

