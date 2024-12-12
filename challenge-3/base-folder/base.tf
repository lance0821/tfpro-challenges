terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_user" "kplabs_user" {
  name = "kplabs-challenge3-user"
}

resource "aws_iam_policy" "assume_role_policy" {
  name        = "AssumeRolePolicy"
  description = "Allows sts:AssumeRole for all IAM roles"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users      = [aws_iam_user.kplabs_user.name]
  policy_arn = aws_iam_policy.assume_role_policy.arn
}

resource "aws_iam_access_key" "kplabs_user_key" {
  user = aws_iam_user.kplabs_user.name
}

resource "aws_iam_role" "ec2_full_access" {
  name = "EC2FullAccess"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/kplabs-challenge3-user"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role" "iam_full_access" {
  name = "IAMFullAccess"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/kplabs-challenge3-user"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2" {
  role       = aws_iam_role.ec2_full_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "iam" {
  role       = aws_iam_role.iam_full_access.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}


output "ec2_fullaccess_role" {
    value = aws_iam_role.ec2_full_access.arn
}

output "iam_fullaccess_role" {
    value = aws_iam_role.iam_full_access.arn
}
