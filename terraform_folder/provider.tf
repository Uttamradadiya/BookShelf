provider "aws" {
   region =  var.region_aws
   access_key = "AKIATCKAQ7BQCPFIKNJP"
   secret_key = "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"   
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.48.0"
    }
  }
}

