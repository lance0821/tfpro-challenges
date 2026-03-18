# Lab 16 — Terraform Workspaces

## Difficulty: Hard
## Skills Tested
- `terraform workspace new / select / list / show`
- `terraform.workspace` interpolation inside config
- When workspaces are appropriate vs. when separate configs are better
- Workspace-aware variable values with `lookup()` and maps
- State file locations per workspace with S3 backend

## Context
Workspaces let you maintain multiple state files from the same config.
This is commonly used for dev/staging/prod environments where the
infrastructure is structurally identical but differs in size or naming.

## The Workspace Mental Model
```
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
→ state stored at: s3://bucket/prefix/dev/terraform.tfstate
→ terraform.workspace == "dev"
```

## Tasks

### Task 1 — Create workspaces and observe state isolation
In a fresh directory with a simple `aws_s3_bucket` resource:
1. Run `terraform workspace new dev`
2. Apply — creates a bucket named `lab16-dev-<random>`
3. Run `terraform workspace new prod`
4. Apply — creates a bucket named `lab16-prod-<random>`
5. Run `terraform workspace select dev` and `terraform state list`

Verify that each workspace has its own state and its own bucket.

### Task 2 — Workspace-aware naming
Use `terraform.workspace` to differentiate resources:
```hcl
resource "aws_s3_bucket" "this" {
  bucket = "lab16-${terraform.workspace}-${random_id.suffix.hex}"
}
```
Also use it for tagging:
```hcl
tags = {
  Environment = terraform.workspace
}
```

### Task 3 — Workspace-aware variable values
Use a map local to drive different instance sizes per workspace:
```hcl
locals {
  instance_type = {
    dev     = "t2.micro"
    staging = "t2.small"
    prod    = "t2.medium"
  }
}

resource "aws_instance" "this" {
  instance_type = local.instance_type[terraform.workspace]
  # ...
}
```
What happens if you create a workspace named `qa` that isn't in the map?
Fix this with a `lookup()` and a default value.

### Task 4 — BUG: Missing workspace in map
```hcl
locals {
  sizes = {
    dev  = "t2.micro"
    prod = "t2.large"
  }
}

resource "aws_instance" "this" {
  instance_type = local.sizes[terraform.workspace]  # BUG when workspace = "staging"
}
```
Fix this bug TWO ways:
1. Using `lookup(local.sizes, terraform.workspace, "t2.micro")`
2. Using a validation block to restrict workspaces to known values

### Task 5 — EXAM TRAP: When NOT to use workspaces
Your colleague proposes using workspaces to manage different AWS accounts
(dev account vs prod account). What are the risks of this approach?
When should you use separate root configurations instead?

Consider:
- Provider authentication per workspace
- Different backend configs per workspace
- Risk of running prod `apply` while on `dev` workspace accidentally

### Task 6 — Workspace + S3 backend
Configure an S3 backend and verify that workspace state files are stored at:
`s3://your-bucket/<workspace>/terraform.tfstate`
Run `aws s3 ls s3://your-bucket/ --recursive` to confirm.

## Success Criteria
- Two workspaces with isolated state, different bucket names
- `lookup()` with default prevents map key errors
- You can articulate 2 reasons NOT to use workspaces for multi-account
