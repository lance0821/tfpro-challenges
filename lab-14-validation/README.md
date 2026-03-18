# Lab 14 — Validation, Preconditions & Postconditions

## Difficulty: Hard
## Skills Tested
- Variable `validation` blocks with custom error messages
- `precondition` and `postcondition` on resources and data sources
- `check` blocks (warning-only health checks)
- Understanding WHEN each validation type fires
- `can()` and `try()` functions for safe validation expressions

## Context
This lab deliberately has BROKEN validation blocks. Your job is to
diagnose why each one fails, fix it, and understand the lifecycle
phase at which each check runs.

## The Critical Distinction (Exam Favorite)
| Type | Fires at | Blocks apply? | Error or warning? |
|------|----------|---------------|-------------------|
| `validation` block | `terraform validate` / `plan` | Yes | Error |
| `precondition` | `plan` or `apply` | Yes | Error |
| `postcondition` | After resource created | Yes | Error |
| `check` block | After apply | No | Warning only |

## Tasks

### Task 1 — Fix broken validation blocks
Each variable below has a broken validation block. Identify and fix every bug:

```hcl
# BUG A: validation condition references another variable
variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev","staging","prod"], var.region)  # BUG
    error_message = "Environment must be dev, staging, or prod."
  }
}

# BUG B: condition is always true
variable "instance_type" {
  type    = string
  default = "t2.micro"

  validation {
    condition     = length(var.instance_type) > 0   # BUG: too loose
    error_message = "Instance type must start with t2. or t3."
  }
}

# BUG C: error_message is missing a period (causes validate failure in some versions)
# and the regex is wrong — it should reject, not accept "invalid"
variable "bucket_prefix" {
  type    = string
  default = "myapp"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.bucket_prefix))
    error_message = "Bucket prefix must contain only lowercase letters, numbers, and hyphens"
  }
}
```

### Task 2 — Add a precondition to a data source
Add a precondition to the `aws_ami` data source that verifies
`var.architecture` is either `"x86_64"` or `"arm64"`. Use:
```hcl
lifecycle {
  precondition {
    condition     = contains(["x86_64", "arm64"], var.architecture)
    error_message = "Architecture must be x86_64 or arm64."
  }
}
```
Test it by passing `architecture = "sparc"` — does it fail at plan or apply?

### Task 3 — Add a postcondition to an EC2 instance
After the instance is created, verify it's in `"running"` state:
```hcl
lifecycle {
  postcondition {
    condition     = self.instance_state == "running"
    error_message = "Instance did not reach running state after creation."
  }
}
```
When does this fire? Can you trigger it without deleting the instance?

### Task 4 — Add a check block (warning only)
Add a `check` block that verifies the AMI creation date is from 2024
or later. This should be a WARNING — not block apply:
```hcl
check "ami_freshness" {
  assert {
    condition     = tonumber(substr(data.aws_ami.this.creation_date, 0, 4)) >= 2024
    error_message = "Warning: AMI may be outdated."
  }
}
```
Change the year to `2099` — what happens when you apply?

### Task 5 — EXAM TRAP
A student writes:
```hcl
variable "cidr_block" {
  type = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "Must be a valid CIDR."
  }
}
```
Does this work? What would `can()` return for `"not-a-cidr"`?
What would it return for `"10.0.0.0/16"`?

## Success Criteria
- All 3 bugs in Task 1 identified and fixed
- `terraform validate` passes
- Precondition fires at plan time for invalid architecture
- Check block produces warning but does not block apply
- You can explain the difference between all four validation types
