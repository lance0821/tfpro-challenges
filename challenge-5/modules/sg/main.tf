locals {
    all_rules = csvdecode(file("${path.module}/sg.csv"))

    app_1_ingress_rules = {for idx,rule in local.all_rules: idx => {
        name = rule.name
        protocol = rule.protocol
        cidr_block = rule.cidr_block
        description = rule.description
        port = rule.port
    } if rule.direction == "in" && rule.description == "app-1"}

        app_2_egress_rules = {for idx,rule in local.all_rules: idx => {
        name = rule.name
        protocol = rule.protocol
        cidr_block = rule.cidr_block
        description = rule.description
        port = rule.port
    } if rule.direction == "out" && rule.description == "app-2"}
}

resource "aws_security_group" "this" {
  for_each = toset(["app-1", "app-2"])
  name        = "${each.value}-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${each.value}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = local.app_1_ingress_rules
  security_group_id = aws_security_group.this["${each.value.description}"].id
  cidr_ipv4         = each.value.cidr_block
  from_port         = tonumber(each.value.port)
  ip_protocol       = each.value.protocol
  to_port           = tonumber(each.value.port)
}

resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = local.app_2_egress_rules
  security_group_id = aws_security_group.this["${each.value.description}"].id
  cidr_ipv4         = each.value.cidr_block
  from_port         = tonumber(each.value.port)
  ip_protocol       = each.value.protocol
  to_port           = tonumber(each.value.port)
}