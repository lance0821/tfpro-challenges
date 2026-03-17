# data "aws_subnets" "challenge_subnets" {
#   filter {
#     name   = "vpc-id"
#     values = [aws_vpc.main.id]
#   }

#   tags = {
#     "Name" = "subnet-subnet*"
#   }

# }

# output "vpc_subnet_ids" {
#   value = data.aws_subnets.challenge_subnets.ids
# }