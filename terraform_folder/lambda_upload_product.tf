data "archive_file" "product-lambda-upload" {
  type        = "zip"
  source_file = "../lambda_functions/bookshelf_put_object.py"
  output_path = "product-lambda-upload.zip"
}


resource "aws_cloudwatch_log_group" "ProductHandler-lambda-upload-LogGroup" {
    name = "/aws/lambda/${aws_lambda_function.bookshelf-upload-lambda.function_name}"   
}

resource "aws_lambda_function" "bookshelf-upload-lambda" {
  function_name    = var.function_upload_name_lambda
  filename         = "product-lambda-upload.zip"
  handler          = var.function_upload_handler_lambda
  runtime          = var.runtime_version
  source_code_hash = data.archive_file.product-lambda-upload.output_base64sha256
  memory_size      = 2048
  timeout          = 3
  role             = aws_iam_role.lambda-exec-upload.arn

  environment {
    variables = {
      private_website_bucket_name = var.website_bucket_name_private
    }
  }
  
}
