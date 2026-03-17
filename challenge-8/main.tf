locals {
    csv_data = csvdecode(file("./sg.csv"))

    cidr_map = {
        app = data.aws_subnet.app.cidr_block
        database = data.aws_subnet.database.cidr_block
        monitoring = data.aws_subnet.central.cidr_block
        anti-virus = data.aws_subnet.central.cidr_block

    }
   # First local: split the port once
raw_ingress = [for row in local.csv_data : {
  protocol   = row.protocol
  cidr_block = local.cidr_map[row.cidr_block]
  ports      = split("-", row.port)
} if row.direction == "in"]

# Second local: derive from/to from the already-split ports
ingress_rules = [for rule in local.raw_ingress : {
  protocol   = rule.protocol
  cidr_block = rule.cidr_block
  from_port  = tonumber(rule.ports[0])
  to_port    = tonumber(rule.ports[length(rule.ports) - 1])
}]
}
resource "aws_security_group" "kplabs_sg" {
    name = "kplabs-sg"
    vpc_id = data.aws_vpc.central.id
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  for_each =   {for idx, rule in local.ingress_rules : idx => rule}
  security_group_id = aws_security_group.kplabs_sg.id

  cidr_ipv4   = each.value.cidr_block
  from_port   = each.value.from_port
  ip_protocol = each.value.protocol
  to_port     = each.value.to_port
}

# output "csv_data" {
#     value = local.ingress_rules
# }

output "ingress_rules" {
    value = aws_vpc_security_group_ingress_rule.ingress
}

output "filtered_data" {
    value = {for idx, rule in local.ingress_rules : idx => {
    cidr_block = rule.cidr_block
    from_port = rule.from_port
    to_port = rule.to_port
    }}
}