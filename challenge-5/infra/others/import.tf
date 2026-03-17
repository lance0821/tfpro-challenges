# instance 1: i-0a1cb01f3f392138a
# sg_1: sg-0420c643a9695d7b3

# instance 2: i-0b78bb84393a7a447
# sg_2: sg-0420c643a9695d7b3

# app-1_sg: sg-0a419f9fc88bb7af1
# app-2_sg: sg-0239829924533c68e


/*
data.aws_subnets.challenge_subnets
aws_instance.this["subnet-05f63875939babae0"]
aws_instance.this["subnet-0b9a7f675128c53fd"]
aws_security_group.this["app-1"]
aws_security_group.this["app-2"]
aws_subnet.challenge_5["subnet1"]
aws_subnet.challenge_5["subnet2"]
aws_subnet.random["subnet1"]
aws_subnet.random["subnet2"]
aws_vpc.main
aws_vpc.random
aws_vpc_security_group_egress_rule.this["1"]
aws_vpc_security_group_egress_rule.this["3"]
aws_vpc_security_group_ingress_rule.this["0"]
aws_vpc_security_group_ingress_rule.this["2"]


aws_vpc_security_group_egress_rule.this["1"]
aws_vpc_security_group_egress_rule.this["3"]
aws_vpc_security_group_ingress_rule.this["0"]
aws_vpc_security_group_ingress_rule.this["2"]

*/

import {
  to = module.ec2.aws_instance.this["subnet-05f63875939babae0"]
  id = "i-0a1cb01f3f392138a"
}

import {
  to = module.ec2.aws_instance.this["subnet-0b9a7f675128c53fd"]
  id = "i-0b78bb84393a7a447"
}

import {
  to = module.sg.aws_security_group.this["app-1"]
  id = "sg-0a419f9fc88bb7af1"
}

import {
  to = module.sg.aws_security_group.this["app-2"]
  id = "sg-0239829924533c68e"
}

import {
  to = module.sg.aws_vpc_security_group_ingress_rule.this["0"]
  id = "sgr-05d5cc23689efa685"
}

import {
  to = module.sg.aws_vpc_security_group_ingress_rule.this["2"]
  id = "sgr-02bb01d9d65e1be7d"
}

import {
  to = module.sg.aws_vpc_security_group_egress_rule.this["1"]
  id = "sgr-0cdeca14e098f5317"
}

import {
  to = module.sg.aws_vpc_security_group_egress_rule.this["3"]
  id = "sgr-0fa328b86cf8297c9"
}
