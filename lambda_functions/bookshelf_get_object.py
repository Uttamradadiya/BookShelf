import json
import boto3
import os
from datetime import datetime

def generate_presigned_url(bucket_name, object_name, expiration=3600):
    s3_client = boto3.client('s3')
    url = s3_client.generate_presigned_url(
        'get_object',
        Params={
            'Bucket': bucket_name,
            'Key': object_name
        },
        ExpiresIn=expiration
    )
    return url

def lambda_handler(event, context):
    try:
        s3 = boto3.client('s3')
        bucket_name = "bookshelf-bucket1"
        dynamodb = boto3.client('dynamodb')
        table_name = "bookshelf-product-data"

        response = dynamodb.scan(TableName=table_name)
        items = response.get('Items', [])

        data = []
        for item in items:
            
            product_title = item.get('product-title', {}).get('S', '')
            upload_time = item.get('upload-time', {}).get('S', '')
            product_name = item.get('product-name', {}).get('S', '')
            product_price = float(item.get('product-price', {}).get('N', '0'))
            product_short_title = item.get('product-short-title', {}).get('S', '')

            presigned_url = generate_presigned_url(bucket_name, product_title)
            
            data.append({
                'product-title': product_title,
                'upload_time': upload_time,
                'presigned_url': presigned_url,
                'product-name': product_name,
                'product-price': product_price,
                'product-short-title': product_short_title
            })

        return {
            'statusCode': 200,
            'body': json.dumps(data)
        }

    except Exception as e:
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps({'message': 'Error generating pre-signed URLs'})
        }
