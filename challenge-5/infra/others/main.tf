data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    region = "us-east-1"
    bucket = "tfstate-llewandowski"
    key = "vpc.tfstate"
    }
  }


module "ec2" {
    source = "../../modules/ec2"
    subnet_ids = data.terraform_remote_state.vpc.outputs.subnet_ids
}

module "sg" {
    source = "../../modules/sg"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}