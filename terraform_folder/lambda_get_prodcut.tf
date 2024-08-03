data "archive_file" "product-lambda-get" {
  type        = "zip"
  source_file = "../lambda_functions/bookshelf_get_object.py"
  output_path = "product-lambda-get.zip"
}

resource "aws_cloudwatch_log_group" "ProductHandler-lambda-get-LogGroup" {
    name = "/aws/lambda/${aws_lambda_function.bookshelf-get-lambda.function_name}"
}

resource "aws_lambda_function" "bookshelf-get-lambda" {
  function_name    = var.function_get_name_lambda
  filename         = "product-lambda-get.zip"
  handler          = var.function_get_handler_lambda
  runtime          = var.runtime_version
  source_code_hash = data.archive_file.product-lambda-get.output_base64sha256
  memory_size      = 2048
  timeout          = 3
  role             = aws_iam_role.lambda-exec-get.arn

  environment {
        variables = {
        private_website_bucket_name = var.website_bucket_name_private
        }
    }

}
