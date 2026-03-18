# Lab 18 — Broken Module Wiring: Three Bugs to Diagnose

## Difficulty: Hard (Exam-Level Debugging)
## Skills Tested
- Reading Terraform error messages precisely
- Tracing values through the module chain
- Variable type mismatches between modules
- Output name mismatches
- Provider configuration errors in modules

## Context
This is a forensic debugging lab. The configuration has three distinct
bugs — each from a different category. Your job is to read the error,
trace it to its root cause, and fix ONLY that bug. Do not refactor.

## The Architecture
Root → module "network" → outputs vpc_id, subnet_id
Root → module "compute" → inputs vpc_id, subnet_id, instance_profile
Root → module "iam"     → outputs instance_profile_name

## Bug 1 — Wrong output name referenced in root
In `root/main.tf`:
```hcl
module "compute" {
  source           = "./modules/compute"
  vpc_id           = module.network.vpc_id
  subnet_id        = module.network.subnet_id
  instance_profile = module.iam.profile_name   # BUG
}
```
In `modules/iam/outputs.tf`:
```hcl
output "instance_profile_name" {   # actual output name
  value = aws_iam_instance_profile.this.name
}
```
**Error you'll see**: `Error: Unsupported attribute`
**Fix**: Change `module.iam.profile_name` to match the actual output name.

## Bug 2 — Variable type mismatch
In `modules/compute/variables.tf`:
```hcl
variable "subnet_ids" {    # expects a LIST
  type = list(string)
}
```
In `root/main.tf`:
```hcl
module "compute" {
  ...
  subnet_ids = module.network.subnet_id   # BUG: passing a string, not a list
}
```
**Error you'll see**: `Error: Incorrect attribute value type`
**Fix**: Either change the variable to `string` OR wrap the value: `[module.network.subnet_id]`

## Bug 3 — Module missing required variable
In `modules/network/variables.tf`:
```hcl
variable "vpc_cidr" {
  type = string
  # No default — required
}
```
In `root/main.tf`:
```hcl
module "network" {
  source = "./modules/network"
  # BUG: vpc_cidr not passed
}
```
**Error you'll see**: `Error: No value for required variable`
**Fix**: Add `vpc_cidr = "10.18.0.0/16"` to the module block.

## Your Tasks

### Task 1 — Set up the broken config
The full broken config is in `broken/`. Run `terraform init` then
`terraform plan`. You will see errors. Do NOT fix all at once.

### Task 2 — Fix bugs in order
Fix Bug 1 first. Run plan again — you should see a different error now.
Fix Bug 2. Run plan again.
Fix Bug 3. Run plan — should succeed.

**Why fix in order?** Sometimes fixing one bug reveals another that was
hidden. Real Terraform debugging works the same way.

### Task 3 — Add Bug 4 (provider alias) yourself
After fixing all three bugs, intentionally introduce a fourth bug:
```hcl
# In modules/compute/main.tf, add this required_providers block:
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.east]   # now the module REQUIRES an alias
    }
  }
}
```
But do NOT update the root's `providers` map. Observe the error.
Then fix it by either removing `configuration_aliases` or wiring it properly.

### Task 4 — EXAM SIMULATION
Given only this error message, identify the root cause and fix:
```
│ Error: Reference to undeclared module
│
│   on main.tf line 22, in output "profile_arn":
│   22:   value = module.identity.instance_profile_arn
│
│ No module call named "identity" is declared in the root module.
```
What are the TWO possible root causes of this error?

## Success Criteria
- All three bugs found and fixed in order
- Each fix is minimal — no unnecessary refactoring
- You can write down the root cause of each bug in one sentence
- Task 4 answered correctly with both possible causes
