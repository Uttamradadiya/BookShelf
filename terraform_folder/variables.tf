variable "region_aws" {
  default = "eu-central-1"
}

variable "website_bucket_name_public" {
  default = "bookshelf-webhost-bucket1"
}

variable "web_hosting_folder_s3" {
  default = "bookshelf"
}

variable "web_hosting_file_s3" {
  default = "index.html"
}

variable "website_bucket_name_private" {
  default = "bookshelf-bucket1"
}

variable "table_name_dynamodb" {
  default = "bookshelf-product-data"
}

variable "function_upload_name_lambda" {
  default = "bookshelf_put_object"
}

variable "function_upload_handler_lambda" {
  default = "bookshelf_put_object.lambda_handler"
}

variable "function_get_name_lambda" {
  default = "bookshelf_get_object"
}

variable "function_get_handler_lambda" {
  default = "bookshelf_get_object.lambda_handler"
}

variable "log_group_upload_cloudwatch" {
  default = "product-upload-lambda"
}

variable "log_group_get_cloudwatch" {
  default = "product-get-lambda"
}

variable "user_pool_domain_cognito" {
  default = "bookstore-du"
}

variable "user_pool_name_cognito" {
  default = "bookshelf-web-user-pool1"
}

variable "user_pool_client_name_cognito" {
  default = "user-pool-client"
}

variable "identity_pool_name" {
  default = "bookshelf-web-identity-pool"
}

variable "runtime_version" {
  default = "python3.8"
}

variable "api_gateway_name" {
  default = "bookshelf-web-put-api"
}

variable "api_gateway_stage_name" {
  default = "devl"
}
