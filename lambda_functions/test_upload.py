import unittest
from unittest import mock
import json
from datetime import datetime
import boto3
from bookshelf_put_object import lambda_handler
import bookshelf_put_object as bookshelf_put_object

class TestLambdaHandler(unittest.TestCase):
    def test_upload(self):
        # Mocking the required dependencies
        s3_client_mock = mock.Mock()
        dynamodb_client_mock = mock.Mock()
        boto3.client = mock.Mock(side_effect=[s3_client_mock, dynamodb_client_mock])

        # Mocking the event data
        file_name = "example_product.jpg"
        product_name = "Example Product"
        product_price = 19.99
        product_short_title = "Example Short Title"
        event = {
            "queryStringParameters": {
                "file_name": file_name,
                "product_name": product_name,
                "product_price": product_price,
                "product_short_title": product_short_title
            }
        }

        # Mocking the response data
        presigned_url = "https://example.com/presigned_url"
        upload_time = datetime.now().isoformat()
        response_data = {
            "statusCode": 200,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST"
            },
            "body": json.dumps({"presigned_url": presigned_url})
        }

        # Mocking the expected AWS service responses
        s3_client_mock.generate_presigned_url.return_value = presigned_url
        dynamodb_client_mock.put_item.return_value = {}

        # Call the lambda_handler function
        response = lambda_handler(event, None)

        # Assertions
        self.assertEqual(response, response_data)
        s3_client_mock.generate_presigned_url.assert_called_once_with(
            ClientMethod="put_object",
            Params={"Bucket": "bookshelf-bucket1", "Key": file_name},
            ExpiresIn=3600
        )
        dynamodb_client_mock.put_item.assert_called_once_with(
            TableName='bookshelf-product-data',
            Item={
                'product-title': {'S': file_name},
                'upload-time': {'S': mock.ANY},
                'product-name': {'S': product_name},
                'product-price': {'N': str(product_price)},
                'product-short-title': {'S': product_short_title}
            }
        )

    def test_lambda_handler_failure(self):
        # Mocking the required dependencies
        s3_client_mock = mock.Mock()
        dynamodb_client_mock = mock.Mock()
        boto3.client = mock.Mock(side_effect=[s3_client_mock, dynamodb_client_mock])

        # Mocking the event data
        file_name = "example_product.jpg"
        event = {
            "queryStringParameters": {
                "file_name": file_name,
                "product_name": "Example Product",  
                "product_price": 19.99,              
                "product_short_title": "Example Short Title" 
            }
        }

        # Mocking the response data
        error_message = "Failed to generate presigned URL and store filename: Some error"
        response_data = {
            "statusCode": 500,
            "headers": {
                "Access-Control-Allow-Origin": "*",
                "Access-Control-Allow-Headers": "Content-Type",
                "Access-Control-Allow-Methods": "POST"
            },
            "body": json.dumps(error_message)
        }

        # Mocking the expected AWS service exceptions
        s3_client_mock.generate_presigned_url.side_effect = Exception("Some error")
        dynamodb_client_mock.put_item.side_effect = Exception("Some error")

        # Call the lambda_handler function
        response = lambda_handler(event, None)

        # Assertions
        self.assertEqual(response, response_data)
        s3_client_mock.generate_presigned_url.assert_called_once()
        dynamodb_client_mock.put_item.assert_not_called()


if __name__ == "__main__":
    unittest.main()
