terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  } 

  backend "s3" {
    bucket         = "goap-state-bucket"
    key            = "global-application-orchestration/terraform.tfstate"  # This is the path within the bucket
    region         = "us-east-1"
    dynamodb_table = "goap-state-lock"
    encrypt        = true
  }
}   

provider "aws" {
  region = "us-east-1"
}

# Data block to retrieve the AWS account ID
data "aws_caller_identity" "current" {}