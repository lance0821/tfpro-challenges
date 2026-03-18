# Lab 15 — Sensitive Data and State Exposure

## Difficulty: Hard
## Skills Tested
- `sensitive = true` on variables and outputs
- What Terraform DOES and DOES NOT protect
- `nonsensitive()` function
- `local_sensitive_file` vs `local_file`
- Reading secrets from state files

## Context
This lab starts with a deliberately UNSAFE configuration. You will first
observe the security problem firsthand, then refactor to a safer pattern.
The key insight: `sensitive = true` hides values in CLI output but does
NOT encrypt them in the state file.

## The Mental Model
```
sensitive = true  →  redacted in CLI, plan, logs
                  →  STILL PLAINTEXT in terraform.tfstate
                  →  STILL returned by terraform output -json
```

## Tasks

### Task 1 — Deploy the bad config and observe the leak
The `main.tf` below creates an IAM access key and outputs the secret
in plaintext. Apply it and observe what appears in the terminal:
```hcl
resource "aws_iam_user" "lab15" {
  name = "lab15-secret-user"
}

resource "aws_iam_access_key" "lab15" {
  user = aws_iam_user.lab15.name
}

output "secret_key" {
  value = aws_iam_access_key.lab15.secret
  # BUG: no sensitive = true
}
```
After apply, run `terraform output secret_key`. See the plaintext secret.

### Task 2 — Fix the output
Add `sensitive = true` to the output. Re-run plan and apply. Now run:
```bash
terraform output secret_key          # should be redacted
terraform output -json secret_key    # should still show value
```
What does this tell you about the limits of sensitive marking?

### Task 3 — Inspect the state file
Run `cat terraform.tfstate | grep secret`. Is the value visible?
Run `terraform show`. Is the value visible?

**Key insight**: The state file always contains plaintext sensitive values.
How would you protect the state file in a team environment?

### Task 4 — Broken sensitive variable
The code below causes an error. Fix it:
```hcl
variable "db_password" {
  type      = string
  sensitive = true
  default   = "SuperSecret123!"
}

output "password_length" {
  # BUG: this fails because length() of a sensitive value is still sensitive
  value = length(var.db_password)
}
```
Fix using `nonsensitive()`. Explain why revealing the LENGTH of a secret
may or may not be a security risk.

### Task 5 — local_sensitive_file
The config below writes credentials to disk with 0644 permissions (world-readable).
Refactor it to use `local_sensitive_file` which enforces 0600 permissions:
```hcl
resource "local_file" "creds" {
  filename = "credentials.txt"
  content  = "secret=${aws_iam_access_key.lab15.secret}"
  # BUG: default file_permission is 0777, content visible to all users
}
```
After applying, verify with `ls -la credentials.txt`.

### Task 6 — EXAM TRAP: Mark the statement TRUE or FALSE
1. `sensitive = true` prevents the value from appearing in `terraform.tfstate`
2. `sensitive = true` prevents the value from appearing in plan output
3. Running `terraform output -json` reveals sensitive values
4. Encrypting the S3 backend state bucket prevents teammates from reading secrets via `terraform show`
5. A variable marked `sensitive = true` cannot be used as a resource name

## Success Criteria
- Secret is redacted in `terraform plan` and `terraform output`
- State file still shows plaintext (you can explain why)
- `local_sensitive_file` creates file with 0600 permissions
- All 6 TRUE/FALSE questions answered correctly
