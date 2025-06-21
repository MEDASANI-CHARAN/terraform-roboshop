terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.92.0"
    }
  }
  backend "s3" {
    bucket = "daws78s.xyz-remote-state"
    key    = "expense-dev-eks"
    region = "us-east-1"
    dynamodb_table = "daws78s.xyz-locking-demo"
  }
}

#provide authentication here
provider "aws" {
  region = "us-east-1"
} 