# Lab 08 — Conditional Resource Creation

## Skills Tested
- `count = var.enabled ? 1 : 0` pattern
- Referencing conditionally-created resources with `[0]`
- Conditional outputs with `try()` and `one()`

## Context
Not every environment needs every resource. A common pattern is to
control resource creation with a boolean variable.

## Tasks

### Task 1 — Conditional S3 bucket
Create a variable `create_bucket` (bool, default true).
Create an `aws_s3_bucket` resource with `count = var.create_bucket ? 1 : 0`.
Run plan with default, then with `-var="create_bucket=false"` and
observe the difference.

### Task 2 — Reference the conditional resource
Create an output `bucket_id` that safely returns the bucket ID when
it exists, or an empty string when it doesn't:
```hcl
output "bucket_id" {
  value = var.create_bucket ? aws_s3_bucket.this[0].id : ""
}
```
Why do you need `[0]` here when `count = 1`?

### Task 3 — Conditional IAM role
Create a variable `create_role` (bool, default true).
Create an `aws_iam_role` conditionally. Also create
`aws_iam_instance_profile` conditionally — it depends on the role existing.
What happens if `create_role = false` but you still reference the profile?

### Task 4 — BUG: Fix the broken conditional
The code below fails. Identify and fix the bug:
```hcl
variable "enable_logging" {
  type    = bool
  default = true
}

resource "aws_s3_bucket" "logs" {
  count  = var.enable_logging ? 1 : 0
  bucket = "my-logs-bucket"
}

output "log_bucket" {
  value = aws_s3_bucket.logs.id   # BUG
}
```

## Success Criteria
- `create_bucket = false` produces 0 resources in plan
- `create_bucket = true` produces 1 resource in plan
- Outputs don't error when resource count is 0
