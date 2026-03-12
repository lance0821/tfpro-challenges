# Challenge 9 — Validation, Checks, and Terraform Test

## Skills Tested
- Variable validation blocks with custom error messages
- Object type constraints and complex variable types
- Preconditions and postconditions on resources and data sources
- `check` blocks for continuous health verification
- `terraform test` framework (`.tftest.hcl` files)

## Exam Objectives
- **2a**: Input variables, type constraints, and custom conditions
- **2b**: Data sources with validation
- **2f**: Managing and observing infrastructure state

## Common Mistakes
- Confusing `validation` blocks (input-time) with `precondition`/`postcondition` (plan/apply-time)
- Forgetting that `check` blocks produce warnings, not errors — they don't block apply
- Using `terraform test` without understanding that it creates real infrastructure by default unless you use `mock_provider`
- Writing validation `condition` expressions that reference other variables (not allowed — can only reference the variable being validated)

## Success Criteria
- `terraform validate` catches bad input before plan
- `terraform plan` fails with a clear precondition error when given an invalid AMI architecture
- `terraform test` runs and all assertions pass
- `check` block produces a warning when the health check condition is not met

## Estimated Time
45–60 minutes

---

## Context

You have been given a Terraform configuration that deploys an EC2 instance with a security group in AWS. The configuration works but has **zero safety rails** — no input validation, no runtime checks, and no tests. Your job is to harden this configuration so that bad inputs fail fast, runtime assumptions are verified, and the configuration has automated test coverage.

This is the single biggest gap on the Terraform Professional exam. The official content list explicitly names validation, checks, custom conditions, and `terraform test` — and none of the previous 8 challenges cover them.

---

## Tasks

### Task 1: Fix the loose variable types

The `variables.tf` file defines several variables with overly permissive types. Tighten them:

- Change `allowed_regions` from `list(string)` to a variable with a **validation block** that only permits `us-east-1`, `us-west-2`, and `eu-west-1`. The error message should say: `"Only us-east-1, us-west-2, and eu-west-1 are approved regions."`
- Change `subnet_config` from `any` to an **object type** that requires exactly two attributes: `subnet_id` (string) and `availability_zone` (string). Both are required.
- Add a **validation block** to `instance_type` that only allows values starting with `t2.` or `t3.`. Use `can(regex(...))` for the check.

### Task 2: Add a second validation to subnet_config

Add a validation block to `subnet_config` that ensures the `subnet_id` value starts with `"subnet-"`. Error message: `"subnet_id must start with 'subnet-'."`

### Task 3: Add a precondition to the AMI data source

The `main.tf` file uses a `data.aws_ami` data source to look up the latest Amazon Linux 2023 AMI. Add a **precondition** inside the data source that verifies `var.required_architecture` is either `"x86_64"` or `"arm64"`. Error message: `"Architecture must be x86_64 or arm64."`

### Task 4: Add a postcondition to the EC2 instance

Add a **postcondition** to the `aws_instance` resource that verifies the instance enters the `"running"` state after creation. Use `self.instance_state == "running"` as the condition. Error message: `"Instance did not reach running state."`

### Task 5: Add a check block for health verification

Create a **`check`** block named `"ami_is_recent"` that contains a data source lookup (`data.aws_ami`) and an `assert` block. The assertion should verify that the AMI's `creation_date` is from the current year (use `substr` to extract the year and compare). This is a **warning-only** check — it should not block apply.

### Task 6: Write a terraform test

In the `tests/main.tftest.hcl` file, write a test with two `run` blocks:

- **Run block 1** (`"valid_input"`): Use `command = plan` with valid variable values. Assert that `terraform plan` succeeds (no assertion needed — success is implicit).
- **Run block 2** (`"invalid_region_rejected"`): Use `command = plan` with `allowed_regions = ["ap-southeast-1"]`. Expect the plan to fail. Use `expect_failures = [var.allowed_regions]` to verify the correct validation fires.

### Task 7: Run terraform validate and terraform test

Run `terraform validate` with the default (valid) variable values and confirm it passes. Then run `terraform test` and confirm both test cases pass (one succeeds, one fails as expected).

### Task 8: Test with bad input

Run `terraform plan` with these bad inputs and verify each produces the correct error:

- `allowed_regions = ["ap-northeast-1"]` → should fail validation
- `instance_type = "m5.large"` → should fail validation
- `subnet_config = { subnet_id = "bad-id", availability_zone = "us-east-1a" }` → should fail validation
- `required_architecture = "sparc"` → should fail precondition during plan
