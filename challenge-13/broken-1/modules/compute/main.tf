terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.80.0"
      configuration_aliases = [aws.west]
    }
  }
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

data "aws_ami" "amazon_linux" {
  provider    = aws.west
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "this" {
  provider      = aws.west
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}

output "instance_id" {
  value = aws_instance.this.id
}

output "instance_region" {
  value = "us-west-2 (via aliased provider)"
}
