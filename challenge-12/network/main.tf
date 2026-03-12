terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }

  # TODO (Task 1): Add an S3 backend configuration for state storage.
  # Use key = "challenge-12/network/terraform.tfstate"
  # Consider adding DynamoDB table for state locking.
}

provider "aws" {
  region = "us-east-1"
}

# --- NETWORK RESOURCES ---

resource "aws_vpc" "main" {
  cidr_block           = "10.12.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "challenge-12-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.12.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "challenge-12-public-a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.12.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "challenge-12-public-b"
  }
}

# --- OUTPUTS ---
# These outputs will be consumed by the application config via terraform_remote_state.

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "subnet_b_id" {
  value = aws_subnet.public_b.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}
