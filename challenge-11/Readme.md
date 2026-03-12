# Challenge 11 — Sensitive Data and Secret Hygiene

## Skills Tested
- Marking variables as `sensitive = true`
- Understanding what Terraform redacts in CLI output vs. what persists in state
- Fixing outputs that leak sensitive values
- Using `nonsensitive()` function where appropriate
- Inspecting state files for secret exposure

## Exam Objectives
- **2f**: Managing sensitive data in Terraform
- **1d**: State file security implications
- **2e**: Complex variable types and outputs with sensitivity

## Common Mistakes
- Believing that `sensitive = true` on a variable protects the value in the state file (it does not)
- Forgetting to mark outputs as `sensitive = true` when they derive from sensitive inputs
- Using `nonsensitive()` carelessly — it strips the sensitive flag and exposes the value
- Not understanding that `terraform show` on a state file reveals all sensitive values in plaintext

## Success Criteria
- You can identify which output leaks a secret in the original config
- After fixes, `terraform plan` and `terraform apply` redact all sensitive values in CLI output
- You can demonstrate that the state file still contains the plaintext secret (and explain why)
- You understand the difference between CLI redaction and state-level protection

## Estimated Time
30–40 minutes

---

## Context

You have been given a Terraform configuration that creates an AWS IAM user with an access key and stores credentials in local files. The configuration **works** but has serious security problems: sensitive values leak in outputs, the state file contains plaintext secrets, and there are no guardrails to prevent accidental exposure.

Your job is to start with this "bad" configuration, observe the security problems firsthand, and then refactor it into a safer pattern. This is not about making Terraform theoretically secure — it is about understanding exactly what Terraform does and does not protect, which is how the exam tests this topic.

---

## Tasks

### Task 1: Deploy the bad configuration

Run `terraform apply -auto-approve` with the default variables. Observe the output carefully. You should see:
- An IAM user created
- An access key generated
- **The secret access key printed in plaintext in the terminal output**

Note which output block is leaking the secret.

### Task 2: Inspect the state file

Run `terraform show` to examine the state. Find the `aws_iam_access_key` resource and note:
- Is the `secret` attribute visible in plaintext?
- Is the `ses_smtp_password_v4` visible?
- Would encrypting the S3 backend state file protect against a teammate running `terraform show`?

### Task 3: Mark the password variable as sensitive

The `variables.tf` file has a `db_password` variable that is not marked sensitive. Add `sensitive = true` to it. Then run `terraform plan` and observe how Terraform now redacts the value in the plan output.

### Task 4: Fix the leaking output

The `outputs.tf`-style output block in `main.tf` named `iam_secret_key` exposes the secret access key without any sensitivity marking. Fix this in **two ways**:
1. Add `sensitive = true` to the output block
2. Alternatively, remove the output entirely — ask yourself whether there is ever a valid reason to output a secret access key

### Task 5: Understand nonsensitive()

Add a new output called `secret_key_length` that outputs the **length** of the secret access key (using `length()`) without marking it sensitive. You will need to wrap the value with `nonsensitive()` since it derives from a sensitive attribute. Explain: does revealing the length of a secret constitute a security risk?

### Task 6: Refactor the local_file resource

The `main.tf` creates a `local_file` that writes credentials to disk. This is a common anti-pattern. Refactor it to use `local_sensitive_file` instead, which sets restrictive file permissions (0600) automatically. Verify that `terraform plan` shows the file content as `(sensitive value)`.

After applying, check the file permissions with `ls -la` to confirm they are `0600`.
