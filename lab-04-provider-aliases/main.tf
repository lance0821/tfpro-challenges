terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}

# TODO (Task 1): Default provider — us-east-1
provider "aws" {
  region = "us-east-1"
}

# TODO (Task 1): Aliased provider — us-west-2
# provider "aws" {
#   alias  = "west"
#   region = "us-west-2"
# }

# TODO (Task 3): Call east bucket module
# module "east_bucket" { ... }

# BUG (Task 4): Fix the providers map key below before uncommenting
# module "west_bucket" {
#   source        = "./modules/bucket"
#   bucket_suffix = "west"
#   providers = {
#     aws.wrong = aws.west   # BUG: this key must match configuration_aliases in the child module
#   }
# }
