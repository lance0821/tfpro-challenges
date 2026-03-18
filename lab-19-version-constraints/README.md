# Lab 19 — Version Constraints and Lock File Conflicts

## Difficulty: Hard
## Skills Tested
- Terraform version constraint operators: `=`, `~>`, `>=`, `<=`, `!=`
- `.terraform.lock.hcl` structure and purpose
- `terraform init -upgrade` vs plain `terraform init`
- Child module provider version inheritance
- Diagnosing version conflicts without running Terraform

## Context
This is a forensic lab. The configuration has pre-built version conflicts.
You must diagnose each conflict from reading the files BEFORE running
any Terraform commands, then verify your diagnosis by running `terraform init`.

## The Lock File Mental Model
```
.terraform.lock.hcl records:
  - The exact version selected
  - The constraints it was selected under
  - Cryptographic hashes for verification

terraform init (without -upgrade):
  - MUST use the locked version
  - Fails if locked version no longer satisfies constraints

terraform init -upgrade:
  - Selects newest version satisfying ALL constraints
  - Rewrites .terraform.lock.hcl with new version + hashes
```

## Broken Configs to Diagnose

### Config A — main.tf requires 5.30.0 exactly, lock has 5.80.0
```hcl
# main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.30.0"   # exact pin
    }
  }
}
```
```hcl
# .terraform.lock.hcl
provider "registry.terraform.io/hashicorp/aws" {
  version     = "5.80.0"
  constraints = "~> 5.80.0"
}
```
**Question**: Will `terraform init` succeed? Will `terraform init -upgrade` succeed?
What version will be installed after `-upgrade`?

### Config B — Child module demands 4.x, root demands 5.x
```hcl
# root/main.tf
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}
```
```hcl
# modules/storage/main.tf
terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 4.0" }  # CONFLICT
  }
}
```
**Question**: Can `~> 5.0` and `~> 4.0` ever be satisfied simultaneously?
What is the fix?

### Config C — required_version vs actual Terraform binary
```hcl
terraform {
  required_version = ">= 1.8.0"   # but you're running 1.6.3
}
```
**Question**: When does Terraform check `required_version`? Is it init, plan, or apply?
Can `-upgrade` fix this?

## Tasks

### Task 1 — Diagnose without running Terraform
For each config A, B, and C above:
1. Read the files
2. Write your diagnosis (what will fail and why)
3. Write your proposed fix
4. Run `terraform init` to verify your diagnosis

### Task 2 — Fix Config A
Change the version constraint to use `~>` instead of `=`.
What does `~> 5.80.0` allow vs `~> 5.0`?
Run `terraform init -upgrade` — does the lock file update?

### Task 3 — Fix Config B
You have two options:
1. Change the child module to `~> 5.0` (preferred)
2. Remove the `required_providers` block from the child module
   (child modules inherit from root when not specified)

Implement option 1. Explain why option 2 might be risky.

### Task 4 — Interpret lock file hashes
Given a lock file entry:
```hcl
provider "registry.terraform.io/hashicorp/aws" {
  version     = "5.80.0"
  constraints = "~> 5.80.0"
  hashes = [
    "h1:abc123...",
    "zh:def456...",
  ]
}
```
What is the `h1:` hash used for?
What is the `zh:` hash used for?
What happens if you manually edit a hash value?

### Task 5 — EXAM TRAP: Constraint operator quiz
For each constraint below, state the RANGE of versions it allows:
1. `= 5.20.0`     → ?
2. `~> 5.20.0`    → ?
3. `~> 5.20`      → ?
4. `>= 5.0, < 6.0`→ ?
5. `!= 5.50.0`    → ?

### Task 6 — When to commit the lock file
Should `.terraform.lock.hcl` be committed to version control?
What are the arguments for and against?
What is HashiCorp's official recommendation?

## Success Criteria
- All three configs diagnosed correctly BEFORE running Terraform
- Task 5 constraint quiz answered correctly (check against Terraform docs)
- Lock file behavior with and without `-upgrade` clearly understood
- You can explain the difference between `h1:` and `zh:` hashes
