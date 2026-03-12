# Challenge 12 — Automation and Non-Interactive Workflows

## Skills Tested
- Non-interactive `terraform init`, `plan`, and `apply` workflows
- Saved plan files (`-out=tfplan`) and applying from plan files
- `terraform fmt -check` and `terraform validate` as CI gates
- `-detailed-exitcode` for conditional pipeline logic
- Cross-configuration data sharing with `terraform_remote_state`
- State locking awareness with S3/DynamoDB backends

## Exam Objectives
- **3c**: Using Terraform in automation / non-interactive workflows
- **3d**: State locking and concurrent access
- **3b**: Remote state data sharing between configurations
- **1a**: `init`, `plan`, `apply` workflow with saved plans

## Common Mistakes
- Forgetting `-input=false` in CI — Terraform will hang waiting for interactive input
- Running `terraform apply` without a saved plan file in CI (non-deterministic — the plan can change between `plan` and `apply`)
- Not understanding `-detailed-exitcode`: exit code 0 = no changes, 1 = error, 2 = changes pending
- Assuming `terraform fmt` modifies files in CI — use `fmt -check` to detect without modifying
- Not configuring state locking and running concurrent applies that corrupt state

## Success Criteria
- The `ci.sh` script runs the full workflow without any interactive prompts
- `terraform fmt -check` and `terraform validate` pass before plan
- The plan is saved to a file and applied from that file (not re-planned)
- The application config successfully reads VPC/subnet data from the network config's remote state
- You can explain what happens when `-detailed-exitcode` returns 0, 1, or 2

## Estimated Time
45–60 minutes

---

## Context

You have two Terraform configurations that must work together: a **network** config (VPC and subnets) and an **application** config (EC2 instance that reads network outputs via remote state). Your job is to make both configurations deployable through a **non-interactive CI/CD-style script** — no prompts, no manual approvals, deterministic saved plans, and proper gating.

This challenge directly targets exam objectives 3c and 3d. The official learning path says to "review how to modify workflows for automation," and community reports confirm that understanding non-interactive Terraform is tested in both labs and multiple-choice.

---

## Tasks

### Task 1: Configure the network backend

In `network/main.tf`, configure an S3 backend for the network state. Use:
- Bucket: use a variable or hardcode a unique name (you will need to create this bucket manually or via a separate config)
- Key: `challenge-12/network/terraform.tfstate`
- Region: `us-east-1`
- DynamoDB table for state locking (optional but recommended — create one or use an existing table)

Apply the network configuration to create the VPC and subnets, and verify outputs are available.

### Task 2: Configure the application to read remote state

In `application/main.tf`, add a `terraform_remote_state` data source that reads the network configuration's state file from S3. Use the outputs to get the VPC ID and subnet IDs for the EC2 instance. The application should **never hardcode** network values.

### Task 3: Complete the CI script

The `ci.sh` file has a skeleton workflow. Complete it so that it:

1. Runs `terraform fmt -check -recursive` — fails the script if formatting is wrong
2. Runs `terraform init -input=false` — no interactive prompts
3. Runs `terraform validate` — fails the script if config is invalid
4. Runs `terraform plan -input=false -detailed-exitcode -out=tfplan`
   - Exit code 0: no changes needed, skip apply
   - Exit code 1: error, fail the script
   - Exit code 2: changes pending, proceed to apply
5. Runs `terraform apply tfplan` (applies the saved plan, not a new plan)

### Task 4: Add format and validation checks

Intentionally break the formatting in one `.tf` file (e.g., add extra spaces or wrong indentation). Run `ci.sh` and verify it fails at the `fmt -check` step. Fix the formatting and run again.

### Task 5: Test the detailed-exitcode behavior

Run the CI script when infrastructure is already up-to-date (no changes). Verify that the script detects exit code 0 from `terraform plan -detailed-exitcode` and skips the apply step. Then make a small change (e.g., add a tag) and run again — verify it detects exit code 2 and proceeds to apply.

### Task 6: Add a check block

Add a `check` block to the application configuration that verifies the EC2 instance's `instance_state` is `"running"` after apply. This should produce a warning (not an error) if the condition is not met.

### Task 7: Test state locking awareness

If you configured DynamoDB locking in Task 1, open two terminals and try to run `terraform apply` simultaneously against the same state. Observe the lock error. Explain:
- What error message do you see?
- What is the lock ID?
- How would you force-unlock if needed (and why is that dangerous)?

### Task 8: Destroy infrastructure

Run the CI script in "destroy" mode or manually destroy both configurations in reverse order (application first, then network). Explain why order matters when configurations depend on each other's state.
