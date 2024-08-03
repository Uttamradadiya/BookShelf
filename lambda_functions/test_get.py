import unittest
from unittest.mock import patch
import json
from bookshelf_get_object import lambda_handler
import bookshelf_get_object as bookshelf_get_object

class TestLambdaFunction(unittest.TestCase):

    @patch('bookshelf_get_object.boto3.client')
    def test_lambda_handler(self, mock_client):
        # Mock the DynamoDB response
        mock_client.return_value.scan.return_value = {
            'Items': [
                {
                    'product-title': {'S': 'Product 1'},
                    'upload-time': {'S': '2023-12-28'},
                    'product-name': {'S': 'ProductName1'},
                    'product-price': {'N': '10.5'},
                    'product-short-title': {'S': 'ShortTitle1'}
                },
                {
                    'product-title': {'S': 'Product 2'},
                    'upload-time': {'S': '2023-12-28'},
                    'product-name': {'S': 'ProductName2'},
                    'product-price': {'N': '20.5'},
                    'product-short-title': {'S': 'ShortTitle2'}
                }
            ]
        }

        # Mock the S3 response
        mock_presigned_url = 'https://example.com/presigned-url'
        mock_client.return_value.generate_presigned_url.return_value = mock_presigned_url

        # Invoke the Lambda function
        result = bookshelf_get_object.lambda_handler({}, {})

        # Verify the expected response
        expected_data = [
            {
                'product-title': 'Product 1',
                'upload_time': '2023-12-28',
                'presigned_url': mock_presigned_url,
                'product-name': 'ProductName1',
                'product-price': 10.5,
                'product-short-title': 'ShortTitle1'
            },
            {
                'product-title': 'Product 2',
                'upload_time': '2023-12-28',
                'presigned_url': mock_presigned_url,
                'product-name': 'ProductName2',
                'product-price': 20.5,
                'product-short-title': 'ShortTitle2'
            }
        ]
        self.assertEqual(result['statusCode'], 200)
        self.assertEqual(json.loads(result['body']), expected_data)

if __name__ == '__main__':
    unittest.main()
