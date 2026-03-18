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
}
provider "aws" {
  region                   = "us-east-1"
  alias                    = "asg"
  profile                  = "asg"
  shared_config_files      = [".aws/config"]
  shared_credentials_files = [".aws/credentials"]
}

provider "aws" {
  region                   = "us-east-1"
  alias                    = "iam"
  profile                  = "iam"
  shared_config_files      = [".aws/config"]
  shared_credentials_files = [".aws/credentials"]
}

provider "aws" {
  region                   = "us-east-1"
  alias                    = "readonly"
  profile                  = "readonly"
  shared_config_files      = [".aws/config"]
  shared_credentials_files = [".aws/credentials"]
}



module "asg" {
  source = "./asg"
  providers = {
    aws = aws.asg
  }
}

module "iam" {
  source = "./iam"
  providers = {
    aws = aws.iam
  }
}


data "aws_caller_identity" "local" {
  provider = aws.readonly
}

resource "local_file" "this" {
  content  = data.aws_caller_identity.local.account_id
  filename = "account-number.txt"
}