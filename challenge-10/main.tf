terraform {
  # TODO (Task 6): Add a required_version constraint for >= 1.6.0, < 2.0.0

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # BUG: This constraint demands exactly 5.20.0, but the lock file
      # has a different version pinned. This will cause terraform init to fail.
      version = "= 5.20.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- ROOT MODULE RESOURCES ---

resource "random_pet" "name" {
  length = 2
}

resource "aws_s3_bucket" "root_bucket" {
  bucket = "challenge-10-root-${random_pet.name.id}"

  tags = {
    Name        = "challenge-10-root-bucket"
    Environment = "lab"
  }
}

# --- CHILD MODULE ---

module "storage" {
  source = "./modules/storage"

  bucket_prefix = "challenge-10-child"
  pet_name      = random_pet.name.id
}

# --- OUTPUTS ---

output "root_bucket_name" {
  value = aws_s3_bucket.root_bucket.id
}

output "child_bucket_name" {
  value = module.storage.bucket_name
}

output "provider_version_note" {
  value = "If you can see this output in a plan, the version constraints are resolved."
}
