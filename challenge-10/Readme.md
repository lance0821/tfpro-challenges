# Challenge 10 — Version Constraints, Upgrades, and Lock File

## Skills Tested
- Terraform version constraints (`required_version`)
- Provider version constraints (`required_providers`)
- Child module version pinning
- Dependency lock file interpretation (`.terraform.lock.hcl`)
- `terraform init -upgrade` workflow
- Diagnosing and resolving version conflicts

## Exam Objectives
- **3a**: Version constraints for Terraform, providers, and modules
- **5b**: Provider versioning and the dependency lock file
- **5a**: Plugin-based architecture understanding

## Common Mistakes
- Running `terraform init` without `-upgrade` and wondering why the provider doesn't update
- Not understanding the difference between `~>` (pessimistic), `>=` (minimum), and `=` (exact) constraints
- Deleting `.terraform.lock.hcl` instead of understanding why it exists
- Forgetting that child modules can also have their own `required_providers` blocks that must be compatible

## Success Criteria
- You can explain the exact error from the initial broken `terraform init`
- After fixing the constraints, `terraform init -upgrade` succeeds
- `terraform plan` shows a clean plan
- You can describe what changed in `.terraform.lock.hcl` after the upgrade
- The child module is pinned to a specific version

## Estimated Time
30–45 minutes

---

## Context

You have been given a Terraform configuration that **will not initialize**. The root module has provider version constraints that conflict with the lock file, and a child module (`modules/storage`) has its own provider requirement that creates an additional conflict. Your job is to diagnose the errors, understand what the lock file does, fix the constraints, and get to a successful plan.

This challenge directly targets exam objectives 3a and 5b. The official content list explicitly includes version constraints and the dependency lock file, and community reports confirm that candidates are expected to interpret lock file contents and resolve version conflicts under time pressure.

---

## Tasks

### Task 1: Attempt to initialize and read the error

Run `terraform init` in the challenge-10 directory. It will fail. **Read the error message carefully.** Write down (or mentally note):
- Which provider has a version conflict?
- What version does the lock file expect?
- What version does the configuration demand?
- Why can't Terraform resolve this automatically?

### Task 2: Inspect the lock file

Open `.terraform.lock.hcl` and examine its contents. Answer these questions:
- What provider is locked and at what version?
- What are the `h1:` and `zh:` hashes used for?
- What `constraints` field is recorded and what does it represent?
- Would deleting this file fix the problem? Why is that a bad idea in a team setting?

### Task 3: Fix the root module provider constraint

The root module's `main.tf` demands an AWS provider version that conflicts with the lock file. Fix the `required_providers` block so the constraint is compatible. Use a **pessimistic constraint operator** (`~>`) that allows patch-level updates within the 5.x series.

### Task 4: Fix the child module provider constraint

The `modules/storage/main.tf` has its own `required_providers` block with an incompatible constraint. Fix it so the child module's constraint is compatible with the root module's constraint. The child module should accept any 5.x provider version.

### Task 5: Run terraform init -upgrade

Run `terraform init -upgrade` to update the lock file. Then:
- Compare the lock file before and after (use `git diff` or manually compare)
- Note the new provider version and hash values
- Explain why `-upgrade` was necessary (why a plain `terraform init` would still fail even after fixing the constraints, if the lock file pins an old version)

### Task 6: Add a Terraform version constraint

Add a `required_version` constraint to the root module that requires Terraform `>= 1.6.0` and `< 2.0.0`. Verify it passes with your current Terraform version by running `terraform validate`.

### Task 7: Verify with a clean plan

Run `terraform plan` and confirm the configuration is valid. You should see resources from both the root module and the child storage module in the plan output. No errors, no version conflicts.
