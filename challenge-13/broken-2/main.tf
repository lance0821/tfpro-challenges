terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}

# BUG: The profile name here does not match any profile in the
# .aws/credentials or .aws/config files.
provider "aws" {
  region                   = "us-east-1"
  shared_config_files      = ["${path.module}/.aws/config"]
  shared_credentials_files = ["${path.module}/.aws/credentials"]
  profile                  = "deployment"
}

# --- RESOURCES ---

resource "aws_s3_bucket" "test" {
  bucket_prefix = "challenge-13-auth-"

  tags = {
    Name = "challenge-13-auth-test"
  }
}

data "aws_caller_identity" "current" {}

# --- OUTPUTS ---

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "bucket_name" {
  value = aws_s3_bucket.test.id
}
