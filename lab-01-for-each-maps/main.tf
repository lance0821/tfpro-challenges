terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# TODO (Task 2): Create aws_s3_bucket using for_each over var.buckets
# Each bucket name should be "lab01-${each.key}"
# Tag Environment from each.value.environment

# TODO (Task 4): Create aws_s3_bucket_versioning for each bucket
# Reference the bucket using aws_s3_bucket.this[each.key].id
