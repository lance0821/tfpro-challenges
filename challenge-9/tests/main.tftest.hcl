# Terraform Test File for Challenge 9
# TODO: Complete the two run blocks below.

# Run block 1: Verify that valid input produces a successful plan.
# Use command = plan with valid variable values.

run "valid_input" {
  command = plan

  variables {
    allowed_regions      = ["us-east-1"]
    instance_type        = "t2.micro"
    required_architecture = "x86_64"
    subnet_config = {
      subnet_id         = "subnet-12345678"
      availability_zone = "us-east-1a"
    }
  }
}

# Run block 2: Verify that an invalid region is rejected by the
# validation block. Use expect_failures = [var.allowed_regions].

run "invalid_region_rejected" {
  command = plan

  variables {
    allowed_regions = ["ap-southeast-1"]
  }

  expect_failures = [var.allowed_regions]
}
