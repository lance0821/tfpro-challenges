terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}


resource "aws_iam_user" "lb" {
  count = 1
  name  = "success-user"
}

# user = "success-user"
resource "aws_iam_user_policy" "lb_ro" {
  count = length(aws_iam_user.lb)
  name  = "ec2-describe-policy"
  user  = aws_iam_user.lb[count.index].name
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