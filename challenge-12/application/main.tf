terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }

  # TODO: Add an S3 backend for the application state.
  # Use a different key than the network config:
  # key = "challenge-12/application/terraform.tfstate"
}

provider "aws" {
  region = "us-east-1"
}

# --- REMOTE STATE DATA SOURCE ---
# TODO (Task 2): Add a terraform_remote_state data source that reads
# the network configuration's state from S3. Use the outputs to get
# vpc_id and subnet IDs.

# data "terraform_remote_state" "network" {
#   backend = "s3"
#   config = {
#     bucket = "YOUR_BUCKET_NAME"
#     key    = "challenge-12/network/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

# --- DATA SOURCE ---

data "aws_ami" "amazon_linux" {
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

# --- RESOURCES ---

resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"

  # TODO (Task 2): Replace this placeholder with the subnet ID from
  # the terraform_remote_state data source:
  # subnet_id = data.terraform_remote_state.network.outputs.subnet_a_id
  subnet_id = "subnet-placeholder"

  tags = {
    Name = "challenge-12-app"
  }
}

# TODO (Task 6): Add a check block that verifies the instance is in "running" state.
# check "instance_health" {
#   ...
# }

# --- OUTPUTS ---

output "instance_id" {
  value = aws_instance.app.id
}

output "instance_state" {
  value = aws_instance.app.instance_state
}
