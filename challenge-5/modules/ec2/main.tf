resource "aws_instance" "this" {
  for_each      = toset(var.subnet_ids)
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.nano"
  subnet_id     = each.value
} 