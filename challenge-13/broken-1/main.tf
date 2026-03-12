terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}

# Default provider — us-east-1
provider "aws" {
  region = "us-east-1"
}

# Aliased provider — us-west-2
provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}

# --- ROOT MODULE RESOURCES (us-east-1) ---

resource "aws_s3_bucket" "east_bucket" {
  bucket_prefix = "challenge-13-east-"

  tags = {
    Name   = "east-bucket"
    Region = "us-east-1"
  }
}

# --- CHILD MODULE ---
# BUG: The providers map passes the wrong alias name. The child module
# expects a provider named "aws.west" but we're passing something different.
module "compute" {
  source = "./modules/compute"

  providers = {
    # BUG: This key does not match what the child module expects.
    # The child module's configuration_aliases expects "aws.west"
    # but we're passing it under the wrong key.
    aws.wrong_name = aws.us_west
  }

  instance_name = "challenge-13-west-instance"
}

# --- OUTPUTS ---

output "east_bucket_name" {
  value = aws_s3_bucket.east_bucket.id
}

output "west_instance_id" {
  value = module.compute.instance_id
}
