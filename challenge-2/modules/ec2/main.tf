resource "aws_instance" "this" {
  ami                  = "ami-0b6c6ebed2801a5cb"
  instance_type        = "t2.micro"
  iam_instance_profile = var.iam_instance_profile_name

}