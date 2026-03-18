# Lab 20 — Non-Interactive CI/CD Terraform Workflow

## Difficulty: Hard (Exam-Level)
## Skills Tested
- `-input=false` flag behavior
- `terraform plan -out=tfplan` and `terraform apply tfplan`
- `terraform plan -detailed-exitcode` (0, 1, 2)
- `terraform fmt -check` vs `terraform fmt`
- `terraform validate` as a CI gate
- State locking in concurrent pipelines

## Context
This lab simulates the exact CI/CD workflow tested in the exam's automation
lab. Every command must run without ANY interactive prompts. If Terraform
hangs waiting for input, your pipeline hangs forever.

## The Non-Interactive Rules
| Rule | Why |
|------|-----|
| Always pass `-input=false` | Prevents hanging on missing variable prompts |
| Always use saved plan files | Ensures what was reviewed is what gets applied |
| Use `-detailed-exitcode` | Lets CI distinguish "no changes" from "error" |
| Never use `terraform apply` without a plan file in CI | Plan can change between plan and apply |

## The detailed-exitcode Contract
```
Exit code 0 = Success, no changes needed → skip apply
Exit code 1 = Error                      → fail the pipeline
Exit code 2 = Success, changes pending   → proceed to apply
```

## Tasks

### Task 1 — What breaks without -input=false?
Create a config with a variable that has NO default:
```hcl
variable "environment" {
  type = string
  # No default!
}
```
Run `terraform plan` without `-input=false`. What happens?
Now run with `-input=false`. What error do you get instead?
Which behavior is correct for CI?

### Task 2 — Build the ci.sh script
Complete this script so the full pipeline works non-interactively.
Every TODO must be implemented:

```bash
#!/usr/bin/env bash
set -euo pipefail

WORKING_DIR="${1:?Usage: ./ci.sh <directory>}"
cd "$WORKING_DIR"

# Step 1: Format check — fail if any file is not properly formatted
# TODO: Run terraform fmt -check -recursive
# On failure: print error and exit 1

# Step 2: Init — no interactive prompts
# TODO: Run terraform init -input=false

# Step 3: Validate — fail if config is invalid
# TODO: Run terraform validate

# Step 4: Plan with detailed exit code
# TODO: Run terraform plan -input=false -detailed-exitcode -out=tfplan
# Capture the exit code — do NOT let set -e kill the script on exit code 2
# Hint: run the plan command with "|| PLAN_EXIT=$?" to capture the code

# Step 5: Handle exit codes
# TODO: case statement on $PLAN_EXIT
# 0 → echo "No changes" and exit 0
# 1 → echo "Plan failed" and exit 1
# 2 → echo "Changes detected, applying..."

# Step 6: Apply the SAVED plan (not a new plan)
# TODO: terraform apply tfplan

echo "Pipeline complete."
```

### Task 3 — Test each exit code scenario
- **Exit 0**: Apply your config, then run the script again. Does it skip apply?
- **Exit 1**: Introduce a syntax error. Does the script fail at validate?
- **Exit 2**: Add a new resource, run the script. Does it apply?

### Task 4 — fmt -check vs fmt: know the difference
```bash
terraform fmt           # MODIFIES files in place
terraform fmt -check    # READS files, exits 1 if any need reformatting
terraform fmt -check -recursive   # Checks all subdirectories too
```
In CI, which command do you use and why?
What would happen if you used `terraform fmt` (without -check) in CI?

### Task 5 — EXAM TRAP: What's wrong with this CI pipeline?
```bash
terraform init
terraform plan -out=tfplan
# ... wait for approval ...
terraform plan -out=tfplan   # Plan runs AGAIN before apply — BUG
terraform apply tfplan
```
Why is running plan twice a problem? What changed between the two plans?

### Task 6 — State locking in CI
Your CI pipeline has two jobs running in parallel — one for the `network`
stack and one for the `app` stack. Both use the same S3 backend bucket
but DIFFERENT keys. Is there a state locking conflict? Why or why not?

Now change the scenario: both jobs target the SAME stack (same key).
What error will the second job see? What is the recovery procedure?

### Task 7 — Destroy mode
Extend your `ci.sh` to support a `destroy` flag:
```bash
./ci.sh network destroy
```
When destroy mode is active, pass `-destroy` to the plan command.
All other steps (fmt, validate, exit code handling) stay the same.

## Success Criteria
- `ci.sh` runs end-to-end with no interactive prompts on any input
- Exit code 0 skips apply (verified by checking no apply output)
- Exit code 2 applies only the saved plan (verified by checking plan output matches apply)
- You can explain why applying a saved plan is safer than re-planning
- Task 5 answered correctly (plan can change between two separate runs)
