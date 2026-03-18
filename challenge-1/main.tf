terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
 region = "us-east-1"
 default_tags {
   tags = {
     Environment = var.environement
   }
 }
}
resource "random_pet" "this" {}

resource "aws_iam_user" "lb" {
  count = 3
  name = "${random_pet.this.id}-${var.org-name}-${count.index}"
}

# This policy must be associated with all IAM users created through this code.

resource "aws_iam_user_policy" "lb_ro" {
  count = length(aws_iam_user.lb)
  name = "ec2-describe-policy"
  user = aws_iam_user.lb[count.index].name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_s3_bucket" "example" {
  for_each  = var.s3_buckets 
   bucket = "${random_pet.this.id}-${each.value}"
   force_destroy = "true"
}


resource "aws_s3_object" "new_object" {
  for_each  = var.s3_buckets 
  bucket = aws_s3_bucket.example[each.key].id
  key    = "new.txt"
  content = "Success"
}