locals {
  csv_data              = csvdecode(file("./ec2.csv"))
  team_names            = [for row in local.csv_data : row.Team_Name]
  unique_instance_types = toset([for row in local.csv_data : row.instance_type])
  instance_count_by_type = { for type in local.unique_instance_types :
    type => length([for row in local.csv_data : row if row.instance_type == type])
  }

  instance_details = [for row in local.csv_data : {
    team = row.Team_Name
    type = row.instance_type
  }]

  map_of_maps = {for row in local.csv_data : "${row.instance_type}_${row.Region}_${row.Team_Name}" => {
    ami_id = row.AMI_ID
    instance_type = row.instance_type
    region = row.Region
    team_name = row.Team_Name
  }}

}

output "csv_data" {
  value = local.csv_data
}

output "list_amis" {
  value = [for row in local.csv_data : row.AMI_ID]
}

output "unique_team_names" {
  value = toset(local.team_names)
}

output "regions_list_of_lists" {
  value = [for row in local.csv_data : [row.Region]]
}

output "list_list_condition" {
  value = [for row in local.csv_data : [row.Region] if row.instance_type == "nano"]
}

output "instance_count_by_type" {
  value = local.instance_count_by_type
}

# output "instance_count_by_type"{
#     value = {for type in toset([for row in local.csv_data : row.instance_type]) : type => length([for row in local.csv_data : row if row.instance_type == type])}

# }

output "unique_instance_types" {
  value = local.unique_instance_types
}

output "instance_detail" {
  value = local.instance_details
}

output "map_of_maps" {
    value = local.map_of_maps
}