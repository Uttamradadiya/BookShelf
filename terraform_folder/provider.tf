provider "aws" {
   region =  var.region_aws
   access_key = "*****"
   secret_key = "*****"   
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

