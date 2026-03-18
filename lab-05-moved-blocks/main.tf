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

# These are the resources you will move into modules in Tasks 2-4.
# DO NOT change the resource names (web, web_sg) — your moved blocks
# will need to reference them by their current names.

resource "aws_security_group" "web_sg" {
  name        = "lab05-web-sg"
  description = "Lab 05 security group"

  tags = {
    Name = "lab05-web-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0b6c6ebed2801a5cb"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "lab05-web"
  }
}

# TODO (Task 4): Add moved blocks here after creating the modules
# moved {
#   from = aws_instance.web
#   to   = module.compute.aws_instance.web
# }
# moved {
#   from = aws_security_group.web_sg
#   to   = module.network.aws_security_group.web_sg
# }
