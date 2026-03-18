# Lab 01 — for_each with Maps

## Skills Tested
- `for_each` over a map variable
- Accessing `each.key` and `each.value` inside a resource
- Structured variable definitions

## Context
You need to create multiple S3 buckets with different configurations driven
by a map variable. Each bucket has a name suffix and an environment tag.

## Tasks

### Task 1 — Define the variable
In `variables.tf`, create a variable named `buckets` with type `map(object({ environment = string }))`.
Add a default with at least two buckets.

### Task 2 — Create the resources
Use `for_each` over `var.buckets` to create `aws_s3_bucket` resources.
- Bucket name: `"lab01-${each.key}"`
- Tag `Environment` from `each.value.environment`

### Task 3 — Output the bucket names
Create an output named `bucket_names` that produces a map of
`each.key → bucket id` using a `for` expression over the resource.

### Task 4 — Add a bucket policy resource
Using the same `for_each` keys, attach an `aws_s3_bucket_versioning`
resource to each bucket and enable versioning.

## Success Criteria
- `terraform plan` shows exactly as many buckets as entries in your map
- Output is a map, not a list
- Changing the map variable adds/removes only the affected bucket on next plan
