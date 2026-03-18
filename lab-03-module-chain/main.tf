terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
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

# TODO (Task 4): Call module "random" from ./modules/random

# TODO (Task 4): Call module "iam" from ./modules/iam
# Pass name_prefix = module.random.pet_name

# TODO (Task 4): Call module "ec2" from ./modules/ec2
# Pass instance_profile = module.iam.instance_profile_name
# Pass name_tag         = module.random.pet_name
