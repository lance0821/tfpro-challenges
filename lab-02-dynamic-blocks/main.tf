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

locals {
  # TODO (Task 3): Define a single egress rule as a list of one object
  egress_rules = []

  # TODO (Task 4): Filter ingress rules to only privileged ports (< 1024)
  privileged_rules = []
}

resource "aws_security_group" "this" {
  name        = "lab02-sg"
  description = "Lab 02 dynamic block security group"

  # TODO (Task 2): Add a dynamic "ingress" block here
  # iterator name should be "rule" (dynamic "ingress" { iterator = rule ... })
  # Each content block sets from_port, to_port, protocol, cidr_blocks, description

  # TODO (Task 3): Add a dynamic "egress" block here
}
