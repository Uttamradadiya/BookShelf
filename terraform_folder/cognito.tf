resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name_cognito 


  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_uppercase = true
    require_numbers   = true
    require_symbols   = true
  }

  username_attributes = ["email"]


  schema {
    name               = "email"
    attribute_data_type = "String"
    mutable            = true
    required           = true

    string_attribute_constraints {
    min_length = 1
    max_length = 256
    }
  }


 # Configure email verification for sign-ups
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject         = "Verify your email address"
    email_message         = "Your verification code is {####}."
    sms_message           = "Your verification code is {####}."
  }

  # Enable user sign-up and specify verification settings
  auto_verified_attributes   = ["email"] 
  
  mfa_configuration          = "OFF"
  
 email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }
}


resource "aws_cognito_user_pool_domain" "domain" {
  domain       = var.user_pool_domain_cognito
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_ui_customization" "example" {
    css = ".logo-customizable{ max-width: 100%; max-height: 100px}  .banner-customizable {padding: 10px 0px 10px 0px; background-color: #EFDFD9; color: #425661;}.submitButton-customizable {font-size: 14px; font-weight: bold; margin: 20px 0px 10px 0px; height: 40px; width: 100%; color: #fff;  background-color: #064606;} .submitButton-customizable:hover {color: #fff;  background-color: #267426;}" 
    image_file = filebase64("../website/cognito-asset/bookshelflogo.png")
    user_pool_id = aws_cognito_user_pool_domain.domain.user_pool_id
    
}


resource "aws_cognito_user_pool_client" "userpool_client" {
  name                                 = var.user_pool_client_name_cognito
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  callback_urls                        = ["https://${var.website_bucket_name_public}.s3.${var.region_aws}.amazonaws.com/${var.web_hosting_folder_s3}/${var.web_hosting_file_s3}"]
  logout_urls                          = ["https://${var.website_bucket_name_public}.s3.${var.region_aws}.amazonaws.com/${var.web_hosting_folder_s3}/${var.web_hosting_file_s3}"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
  # Set the dependency on the S3 bucket object resource
  depends_on = [aws_s3_object.index]
}


resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name = var.identity_pool_name 
  allow_unauthenticated_identities = true


  cognito_identity_providers {
    client_id               =  aws_cognito_user_pool_client.userpool_client.id//user pool app client id
    provider_name           = "cognito-idp.${var.region_aws}.amazonaws.com/${aws_cognito_user_pool.user_pool.id}" //user pool id
    server_side_token_check = true
  }
}

