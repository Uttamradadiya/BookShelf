resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_gateway_name  
  description = "REST API of bookshelf to connect Lambda functions for puting object into S3 bucket"


  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  parent_id     = aws_api_gateway_rest_api.api.root_resource_id
  path_part     = "{proxy+}"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}


resource "aws_api_gateway_method_response" "api_method_response" {
  rest_api_id    = aws_api_gateway_rest_api.api.id
  resource_id    = aws_api_gateway_resource.api_resource.id
  http_method    = aws_api_gateway_method.api_method.http_method
  status_code    = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.bookshelf-upload-lambda.invoke_arn

  request_parameters = {
    "integration.request.header.Content-Type" = "'multipart/form-data'"
  }

}

resource "aws_lambda_permission" "api_gateway_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bookshelf-upload-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_integration_response" "api_integration_response" {
  rest_api_id    = aws_api_gateway_rest_api.api.id
  resource_id    = aws_api_gateway_resource.api_resource.id
  http_method    = aws_api_gateway_method.api_method.http_method
  status_code    = aws_api_gateway_method_response.api_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_integration.api_integration, aws_api_gateway_method_response.api_method_response]
}

resource "aws_api_gateway_integration_response" "proxy_integration_response" {
  rest_api_id      = aws_api_gateway_rest_api.api.id
  resource_id      = aws_api_gateway_resource.api_resource.id
  http_method      = aws_api_gateway_method.api_method.http_method
  status_code      = "200" 

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  depends_on = [aws_api_gateway_integration.api_integration, aws_api_gateway_method_response.api_method_response]
}

resource "aws_api_gateway_stage" "api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.api_gateway_stage_name
  deployment_id = aws_api_gateway_deployment.api_deployment.id

}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_integration.api_integration,
    aws_api_gateway_method_response.api_method_response,
  ]
}