terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}

provider "aws" {
  region = var.allowed_regions[0]
}

# --- DATA SOURCE ---
# TODO: Add a precondition that validates var.required_architecture
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "architecture"
    values = [var.required_architecture]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- RESOURCES ---
# TODO: Add a postcondition that verifies instance reaches "running" state
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_config.subnet_id

  tags = {
    Name = "challenge-9-validation-lab"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "challenge-9-sg"
  description = "Security group for Challenge 9"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  tags = {
    Name = "challenge-9-sg"
  }
}

# --- OUTPUTS ---
output "instance_id" {
  value = aws_instance.web.id
}

output "ami_id" {
  value = data.aws_ami.amazon_linux.id
}

output "ami_creation_date" {
  value = data.aws_ami.amazon_linux.creation_date
}

# TODO: Add a check block named "ami_is_recent" that warns if the AMI
# creation_date is not from the current year.
