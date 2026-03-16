locals {
  instance_type_map = {
    micro = "t2.micro"
    nano = "t3.nano"
  }
  csv_data = csvdecode(file("${path.module}/ec2.csv"))

  us_east_1_instances = [for row in local.csv_data : {

    instance_type = local.instance_type_map[row.instance_type]
    ami_id        = row.AMI_ID
    region        = row.Region
    team_name     = row.Team_Name
    } if row.Region == "us-east-1"
  ]
}

resource "aws_instance" "this" {
  count = length(local.us_east_1_instances)
  ami = local.us_east_1_instances[count.index].ami_id
  instance_type = local.us_east_1_instances[count.index].instance_type

  tags = {
    Name = local.us_east_1_instances[count.index].team_name
  }
}



output "running_ec2" {
  value = [ for instance in aws_instance.this : {
    id = instance.id
    region = instance.region
    firewall_id = instance.vpc_security_group_ids
    subnet = instance.subnet_id
    type = instance.instance_type
    team = instance.tags.Name
  }
  ]
}


