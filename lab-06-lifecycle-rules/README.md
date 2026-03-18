# Lab 06 — Lifecycle Rules

## Skills Tested
- `create_before_destroy`
- `prevent_destroy`
- `ignore_changes`
- Understanding when each rule is appropriate

## Tasks

### Task 1 — prevent_destroy on an S3 bucket
Create an `aws_s3_bucket` with `lifecycle { prevent_destroy = true }`.
Try running `terraform destroy` and observe the error.
Then remove the lifecycle block and destroy successfully.

**Question to answer**: Why would you use `prevent_destroy` in production?
When would it cause problems?

### Task 2 — create_before_destroy on a security group
Some resources (like security groups attached to instances) cannot be
destroyed while in use. Add `create_before_destroy = true` to an
`aws_security_group` resource. Change the `name` argument
(which forces replacement) and observe the plan — it should show
the new SG being created BEFORE the old one is destroyed.

### Task 3 — ignore_changes on an autoscaling group
Create an `aws_autoscaling_group` with `desired_capacity = 1`.
Add `ignore_changes = [desired_capacity]` to the lifecycle block.
Then change `desired_capacity` to `3` in your config and run
`terraform plan`. Verify that Terraform ignores the change.

**Question to answer**: Why is this useful for autoscaling groups
that scale dynamically at runtime?

### Task 4 — BUG: ignore_changes syntax error
Fix the broken lifecycle block below:
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0b6c6ebed2801a5cb"
  instance_type = "t2.micro"

  lifecycle {
    ignore_changes = "tags"   # BUG: wrong type
  }
}
```

## Success Criteria
- Task 1 destroy fails with lifecycle error, succeeds after removal
- Task 2 plan shows create before destroy sequence
- Task 3 plan shows no changes when desired_capacity differs
- Task 4 syntax error is identified and fixed
