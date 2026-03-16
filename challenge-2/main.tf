terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = var.environement
    }
  }
}

module "ec2" {
  source = "./modules/ec2"
  iam_instance_profile_name = module.iam.iam_instance_profile_name
}

module "iam" {
  source = "./modules/iam"
  name_prefix = module.random.pet_name
}

module "random" {
  source = "./modules/random"
}

module "s3" {
  source = "./modules/s3"
  name_prefix = module.random.pet_name

}

module "sg" {
  source = "./modules/sg"
}




