terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.80.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- RESOURCES ---

resource "random_pet" "name" {
  length = 2
}

resource "aws_iam_user" "lab_user" {
  name = "challenge-11-${random_pet.name.id}"

  tags = {
    Name        = "challenge-11-lab-user"
    Environment = "lab"
  }
}

resource "aws_iam_access_key" "lab_key" {
  user = aws_iam_user.lab_user.name
}

# BUG: This writes the secret access key to a plaintext file with default
# permissions (0644). Anyone on the system can read it.
# TODO (Task 6): Refactor to use local_sensitive_file instead.
resource "local_file" "credentials" {
  filename = "${path.module}/credentials.txt"
  content  = <<-EOT
    [${aws_iam_user.lab_user.name}]
    aws_access_key_id = ${aws_iam_access_key.lab_key.id}
    aws_secret_access_key = ${aws_iam_access_key.lab_key.secret}
    db_password = ${var.db_password}
  EOT
}

# --- OUTPUTS ---

output "iam_user_name" {
  value = aws_iam_user.lab_user.name
}

output "iam_access_key_id" {
  value = aws_iam_access_key.lab_key.id
}

# BUG: This output leaks the secret access key in plaintext in the terminal.
# TODO (Task 4): Fix this — either mark as sensitive or remove entirely.
output "iam_secret_key" {
  value = aws_iam_access_key.lab_key.secret
}

output "db_password_value" {
  value = var.db_password
}

# TODO (Task 5): Add an output called "secret_key_length" that reveals only
# the length of the secret key using nonsensitive(length(...))
