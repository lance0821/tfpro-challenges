terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # BUG: This constraint demands a 4.x provider, which conflicts with
      # the root module's 5.x requirement. Fix this to accept 5.x versions.
      version = "~> 4.0"
    }
  }
}

variable "bucket_prefix" {
  description = "Prefix for the S3 bucket name"
  type        = string
}

variable "pet_name" {
  description = "Random pet name for unique naming"
  type        = string
}

resource "aws_s3_bucket" "child_bucket" {
  bucket = "${var.bucket_prefix}-${var.pet_name}"

  tags = {
    Name        = "${var.bucket_prefix}-bucket"
    Environment = "lab"
    ManagedBy   = "child-module"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.child_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.child_bucket.arn
}
