resource "local_file" "config" {
  depends_on = [
    aws_api_gateway_deployment.api_deployment,
    aws_cognito_identity_pool.identity_pool,
    aws_s3_bucket.website_host
  ]

  filename = "../website/front-end/config.js"
  content  = <<EOT
var config = {
  APIInvokeURL: "${aws_api_gateway_deployment.api_deployment.invoke_url}${aws_api_gateway_stage.api_stage.stage_name}/{proxy+}?file_name=",
  IdentityPoolId: "${replace(aws_cognito_identity_pool.identity_pool.id, "\"", "\\\"")}",
  LambdaFunctionGetName: "${var.function_get_name_lambda}",
  AwsRegion: "${var.region_aws}",
  LogoutUrl: "https://${aws_cognito_user_pool_domain.domain.domain}.auth.${var.region_aws}.amazoncognito.com/logout?response_type=code&client_id=${aws_cognito_user_pool_client.userpool_client.id}&redirect_uri=https://${var.website_bucket_name_public}.s3.${var.region_aws}.amazonaws.com/${var.web_hosting_folder_s3}/${var.web_hosting_file_s3}"
};

module.exports = config;
EOT
}