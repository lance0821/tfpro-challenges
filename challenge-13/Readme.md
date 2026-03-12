# Challenge 13 — Provider Troubleshooting and Debugging

## Skills Tested
- Diagnosing provider alias misconfigurations
- Fixing broken AWS authentication (profiles, assume-role, source_profile)
- Resolving provider version conflicts with the lock file
- Using `TF_LOG` environment variables for debug output
- Understanding Terraform's plugin-based architecture

## Exam Objectives
- **5a**: Plugin-based architecture
- **5b**: Provider versioning and dependency lock file
- **5c**: Provider authentication and configuration
- **5d**: Debugging and troubleshooting provider errors

## Common Mistakes
- Not reading error messages carefully — Terraform's provider errors are specific and diagnostic
- Confusing `provider` blocks with `required_providers` blocks
- Not understanding that child modules inherit provider configurations from the root unless explicitly configured
- Forgetting that `alias` in a provider block must match the `providers` map in a module block
- Not knowing how to use `TF_LOG=DEBUG` or `TF_LOG_PATH` to capture logs

## Success Criteria
- All three broken projects are diagnosed and repaired
- For each project, you can explain the root cause in one sentence
- You have used `TF_LOG` at least once to inspect debug output
- All three projects reach a successful `terraform plan`

## Estimated Time
45–60 minutes

---

## Context

This challenge contains **three deliberately broken Terraform projects**. Each one has a different type of provider failure. Your job is to diagnose the error, understand the root cause, and fix it. This is forensic debugging — the kind of reasoning the exam tests in its "Debugging" lab scenario.

You should work through each broken project independently. Use `TF_LOG=DEBUG` liberally to understand what Terraform is doing under the hood.

---

## Broken Project 1: Wrong Alias Passed to Child Module

**Directory:** `broken-1/`

The root module defines two AWS provider configurations — a default and an aliased `us_west` provider. A child module (`modules/compute`) is supposed to use the `us_west` provider, but the wiring is wrong.

### Tasks

1. Run `terraform init` and then `terraform plan` in `broken-1/`. Read the error.
2. Set `TF_LOG=WARN` and run `terraform plan` again. Look for provider-related warnings.
3. Identify the mismatch between the root module's `providers` map and what the child module expects.
4. Fix the provider alias mapping so the child module uses the `us-west-2` provider.
5. Run `terraform plan` and verify it succeeds with resources in `us-west-2`.

---

## Broken Project 2: Broken Shared Config/Credentials

**Directory:** `broken-2/`

This project uses AWS shared configuration files (`.aws/config` and `.aws/credentials`) to authenticate with different profiles. The configuration has authentication errors that prevent Terraform from assuming the correct IAM roles.

### Tasks

1. Run `terraform init` and `terraform plan` in `broken-2/`. Read the auth error.
2. Inspect the `.aws/config` and `.aws/credentials` files.
3. Identify what is wrong:
   - Is the profile name referenced correctly in the provider block?
   - Does the credentials file have the right profile section?
   - Is the `source_profile` configured for role assumption?
4. Fix the configuration files so authentication works.
5. Run `terraform plan` and verify the configuration initializes without auth errors.

---

## Broken Project 3: Provider Version Conflict with Lock File

**Directory:** `broken-3/`

This project has a `.terraform.lock.hcl` that locks the AWS provider to one version, but the `required_providers` block demands a completely different version. The `random` provider also has a conflict.

### Tasks

1. Run `terraform init` in `broken-3/`. Read the version conflict error.
2. Inspect `.terraform.lock.hcl` and compare with `required_providers` in `main.tf`.
3. Decide on the correct fix: should you change the constraint or upgrade the lock file?
4. Fix the version constraints and run `terraform init -upgrade`.
5. Verify the lock file now matches the constraints.
6. Run `terraform plan` and verify it succeeds.
