data "aws_vpc" "central" {
  filter {
    name   = "tag:Name"
    values = ["central-vpc"]
  }
}

data "aws_subnet" "app" {
  filter {
    name   = "tag:Name"
    values = ["app-subnet"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.central.id]
  }
}

data "aws_subnet" "database" {
  filter {
    name   = "tag:Name"
    values = ["database-subnet"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.central.id]
  }
}

data "aws_subnet" "central" {
  filter {
    name   = "tag:Name"
    values = ["central-subnet"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.central.id]
  }
}

output "subnet_ids" {
  value = {
    app-subnet      = data.aws_subnet.app.cidr_block
    database-bubnet = data.aws_subnet.database.cidr_block
    central-subnet  = data.aws_subnet.central.cidr_block
  }
}