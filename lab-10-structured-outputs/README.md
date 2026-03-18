# Lab 10 — Structured Outputs: List of Maps and Map of Maps

## Skills Tested
- Complex output types
- `for` expressions in output blocks
- `tomap()`, `tolist()`, `toset()` type conversion functions
- Understanding when outputs are lists vs maps

## Context
Outputs that return complex structures are common in module design.
When a module creates multiple resources, it often needs to return
structured data about all of them.

## Tasks

### Task 1 — List of maps output
Create 3 IAM users using `count`. Output a **list of maps** where
each map contains the user's `name` and `arn`:
```hcl
output "users" {
  value = [for u in aws_iam_user.this : { name = u.name, arn = u.arn }]
}
```
Verify the output structure with `terraform console`:
```
> terraform console
> output.users[0].name
```

### Task 2 — Map of maps output (keyed by name)
Create S3 buckets using `for_each`. Output a **map of maps** where
the outer key is the bucket's `for_each` key, and the inner map
contains `id` and `arn`:
```hcl
output "buckets" {
  value = { for k, v in aws_s3_bucket.this : k => { id = v.id, arn = v.bucket_arn } }
}
```

### Task 3 — Sensitive output
Create an IAM access key. Output the `id` (not sensitive) and
`secret` (sensitive). Mark only the secret output as sensitive.
What does `terraform output` show for each?

### Task 4 — BUG: Fix the type mismatch
The output below causes a type error. Identify why and fix it:
```hcl
resource "aws_iam_user" "this" {
  count = 3
  name  = "lab10-user-${count.index}"
}

output "user_map" {
  # BUG: count-based resources produce a list, not a map.
  # This for expression tries to use list elements as map keys.
  value = { for u in aws_iam_user.this : u => u.arn }
}
```

## Success Criteria
- `terraform output -json` produces valid JSON with the expected structure
- Sensitive output is redacted in CLI but visible with `terraform output -json`
- You can access nested values with `output.buckets["key"].id`
