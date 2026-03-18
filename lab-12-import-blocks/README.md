# Lab 12 — Import Blocks (Terraform 1.5+)

## Difficulty: Hard
## Skills Tested
- `import` block syntax (declarative import)
- Generating config with `terraform plan -generate-config-out`
- Reconciling generated config with actual resource state
- Understanding what makes `terraform plan` show 0 changes after import

## Context
A colleague manually created an S3 bucket, IAM role, and security group
in the AWS console. You need to bring all three under Terraform management
WITHOUT deleting and recreating them. This is one of the most common
real-world Terraform tasks and a confirmed exam lab scenario.

## The Hard Part
Terraform generates config that is often INCOMPLETE or uses deprecated
arguments. You must edit the generated config until `terraform plan`
shows exactly 0 changes. This requires knowing what attributes Terraform
tracks vs what AWS sets automatically.

## Tasks

### Task 1 — Manual pre-requisite
In the AWS console (or via CLI), create:
- An S3 bucket named `lab12-import-<your-initials>`
- An IAM role named `lab12-import-role` with an EC2 assume-role policy
- A security group named `lab12-import-sg` in the default VPC

Note all their IDs/names — you'll need them for the import blocks.

### Task 2 — Write import blocks
In `imports.tf`, write `import` blocks for all three resources:
```hcl
import {
  to = aws_s3_bucket.lab12
  id = "lab12-import-<your-initials>"
}

import {
  to = aws_iam_role.lab12
  id = "lab12-import-role"
}

import {
  to = aws_security_group.lab12
  id = "<sg-id-from-console>"
}
```

### Task 3 — Generate config
Run:
```bash
terraform plan -generate-config-out=generated.tf
```
Review `generated.tf` carefully. What attributes did Terraform add that
you didn't explicitly set? What might cause a non-zero plan?

### Task 4 — Reconcile to zero changes
Edit your `main.tf` (or use `generated.tf` as a starting point) until:
```
Plan: 0 to add, 0 to change, 0 to destroy.
```
Common issues to fix:
- S3 bucket may have `force_destroy` defaulting differently
- IAM role may have `managed_policy_arns` or `inline_policy` blocks
- Security group may have default egress rules Terraform doesn't track

### Task 5 — Remove the import blocks
Once plan shows 0 changes, delete the `import` blocks from `imports.tf`.
Run `terraform plan` again — it must still show 0 changes. If it doesn't,
your config has drifted from the state.

### Task 6 — EXAM TRAP: What's wrong with this import block?
```hcl
import {
  to = module.storage.aws_s3_bucket.main
  id = aws_s3_bucket.existing.id   # BUG
}
```
Explain why this fails and what the `id` field must be.

## Success Criteria
- All three resources imported with 0 planned changes
- Import blocks removed after successful import
- You can explain why `id` in an import block must be a literal string
