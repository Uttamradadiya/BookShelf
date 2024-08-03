output "APIInvokeURL" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}${aws_api_gateway_stage.api_stage.stage_name}/{proxy+}?file_name="
}

output "cognito_aws_hosted_ui_url" {
    
    value = "https://${aws_cognito_user_pool_domain.domain.domain}.auth.${var.region_aws}.amazoncognito.com/login?response_type=code&client_id=${aws_cognito_user_pool_client.userpool_client.id}&redirect_uri=https://${var.website_bucket_name_public}.s3.${var.region_aws}.amazonaws.com/${var.web_hosting_folder_s3}/${var.web_hosting_file_s3}"
}

output "IdentityPoolId" {
  value = aws_cognito_identity_pool.identity_pool.id
}
