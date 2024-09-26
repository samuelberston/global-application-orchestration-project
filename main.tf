terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  } 
}   

provider "aws" {
  region = "us-east-1"
}

# Data block to retrieve the AWS account ID
data "aws_caller_identity" "current" {}