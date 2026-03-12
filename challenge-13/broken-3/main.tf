terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # BUG: The lock file has 5.80.0 pinned, but this demands exactly 5.30.0.
      # terraform init will fail because the lock file and constraint disagree.
      version = "= 5.30.0"
    }
    random = {
      source = "hashicorp/random"
      # BUG: The lock file has 3.6.0 pinned, but this demands a 2.x version.
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- RESOURCES ---

resource "random_pet" "name" {
  length = 2
}

resource "aws_s3_bucket" "test" {
  bucket = "challenge-13-version-${random_pet.name.id}"

  tags = {
    Name = "challenge-13-version-test"
  }
}

# --- OUTPUTS ---

output "bucket_name" {
  value = aws_s3_bucket.test.id
}

output "pet_name" {
  value = random_pet.name.id
}
