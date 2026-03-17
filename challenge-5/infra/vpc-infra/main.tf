terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "tfstate-llewandowski"
    key    = "vpc.tfstate"

  }
}

module "vpc" {
  source = "../../modules/vpc"
}