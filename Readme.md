# Terraform Professional Challenges

These challenges are part of the HashiCorp Certified: Terraform Authoring and Operations Professional 2025 video course by Zeal Vora.

The challenges are designed to be lengthy and moderately difficult to prepare you for the exams.

Introductory videos on the challenges and detailed solution videos are available in the course.

All the Best!

---

## Exam Objective Matrix

The table below maps every challenge to the official exam domains and sub-objectives. Use it to track your coverage and identify areas that need more practice.

| Challenge | Title | Exam Domain(s) | Sub-Objectives | Type |
|-----------|-------|-----------------|----------------|------|
| **1** | Fix Broken Code, Outputs, State Import/Remove | 1 — Resource Lifecycle | 1a (init/plan/apply/destroy), 1b (import), 1c (state management) | Hands-on |
| **2** | Monolith-to-Modules Refactoring | 2, 4 — Dynamic Config, Modules | 2b (data sources), 2d (meta-arguments), 4a (module creation), 4c (refactoring) | Hands-on |
| **3** | Multi-Provider, IAM Roles, Lifecycle | 1, 5 — Lifecycle, Providers | 1e (lifecycle meta-arguments), 5c (auth/profiles), 5a (provider config) | Hands-on |
| **4** | CSV Data, Count, Conditional Creation | 2 — Dynamic Configuration | 2c (functions), 2d (count/for_each), 2e (complex outputs) | Hands-on |
| **5** | Data Sources, Remote Backend, Modules, Import | 1, 2, 3 — Lifecycle, Dynamic, Collaborative | 1b (import), 2b (data sources), 3b (remote state), 4a (modules) | Hands-on |
| **6** | Advanced AWS Profiles and Role Assumption | 5 — Providers | 5c (authentication), 5a (provider configuration), 5d (troubleshooting) | Hands-on |
| **7** | CSV Processing, Locals, Complex Outputs | 2 — Dynamic Configuration | 2c (functions/expressions), 2e (complex types/outputs) | Hands-on |
| **8** | Data Sources, Security Group Rules, Filtering | 2 — Dynamic Configuration | 2b (data sources), 2c (for expressions), 2e (structured outputs) | Hands-on |
| **9** | Validation, Checks, and Terraform Test | 2 — Dynamic Configuration | 2a (validation, type constraints, custom conditions, tests) | Hands-on |
| **10** | Version Constraints, Upgrades, Lock File | 3, 5 — Collaborative, Providers | 3a (version constraints), 5b (lock file/provider versions) | Hands-on |
| **11** | Sensitive Data and Secret Hygiene | 2 — Dynamic Configuration | 2f (sensitive data), 1d (state security) | Hands-on |
| **12** | Automation and Non-Interactive Workflows | 3 — Collaborative Workflows | 3c (automation), 3d (state locking), 3b (remote state sharing) | Hands-on |
| **13** | Provider Troubleshooting and Debugging | 5 — Providers | 5a (plugin architecture), 5b (versioning), 5c (auth), 5d (debugging) | Hands-on |
| **14** | HCP Terraform Scenario Pack | 6 — HCP Terraform | 6a (run workflow), 6b (workspaces), 6c (credentials/variables), 6d (policy/governance) | Multiple-choice |

### Domain Coverage Summary

| Exam Domain | Sub-Objectives | Challenges |
|-------------|---------------|------------|
| **1 — Manage Resource Lifecycle** | 1a–1e | 1, 2, 3, 5 |
| **2 — Dynamic Configuration** | 2a–2f | 2, 4, 5, 7, 8, **9**, **11** |
| **3 — Collaborative Workflows** | 3a–3d | 5, **10**, **12** |
| **4 — Modules** | 4a–4d | 2, 3, 5 |
| **5 — Providers** | 5a–5d | 3, 6, **10**, **13** |
| **6 — HCP Terraform** | 6a–6d | **14** |

Challenges in **bold** are new additions that close gaps identified in the original 8-challenge set.

---

## Recommended Study Order

1. Complete challenges 1–8 in order (course sequence)
2. Challenge 9 (validation/tests) — closes the biggest single exam gap
3. Challenge 10 (version constraints) — directly tested in labs
4. Challenge 11 (sensitive data) — exam tests judgment, not just mechanics
5. Challenge 12 (automation) — CI/CD patterns are exam-relevant
6. Challenge 13 (provider debugging) — forensic reasoning under time pressure
7. Challenge 14 (HCP Terraform) — study pack for the multiple-choice section

---

## Practice Labs — Additional Exercises

The `practice-labs/` folder contains 20 additional exercises designed for
exam-pressure repetition. These labs cover the same objectives from different
angles so concepts stick through repeated exposure.

### Practice Lab Matrix

| Lab | Topic | Exam Objective | Type | Difficulty |
|-----|-------|----------------|------|------------|
| 01 | `for_each` with maps | 2d | Clean starter | Medium |
| 02 | Dynamic blocks | 2d | Clean starter | Medium |
| 03 | Three-module chain | 4a, 4b | Clean starter | Medium |
| 04 | Provider aliases (multi-region) | 5a, 5c | Broken to fix | Hard |
| 05 | `moved` blocks refactoring | 4c | Flat config to refactor | Hard |
| 06 | Lifecycle rules | 1e | Mixed | Medium |
| 07 | `templatefile()` + user data | 2c | Clean starter | Medium |
| 08 | Conditional resources | 2d | Broken to fix | Medium |
| 09 | Locals + `for` expressions | 2c, 2e | Clean starter | Hard |
| 10 | Structured outputs | 2e | Broken to fix | Hard |
| 11 | Data sources deep dive | 2b | Mixed | Hard |
| 12 | `import` blocks (Terraform 1.5+) | 1b | Real AWS required | Hard |
| 13 | `terraform_remote_state` two-stack | 3b | Real AWS required | Hard |
| 14 | Validation + preconditions + check | 2a | Broken to fix | Hard |
| 15 | Sensitive data and state exposure | 2f, 1d | Broken to fix | Hard |
| 16 | Terraform workspaces | 3b | Mixed | Hard |
| 17 | `count` vs `for_each` tradeoffs | 2d | Broken to fix | Hard |
| 18 | Broken module wiring (3 bugs) | 4a, 5d | Broken to fix | Hard |
| 19 | Version constraints + lock file | 3a, 5b | Broken to fix | Hard |
| 20 | Non-interactive CI/CD workflow | 3c, 3d | Script to complete | Hard |

### Recommended Practice Lab Order

**Phase 1 — Foundation (Labs 1–3, 6–9)**
Cleaner starter labs. Build muscle memory on `for_each`, dynamic blocks,
module wiring, and HCL functions before tackling the harder labs.

**Phase 2 — Debugging under pressure (Labs 4, 8, 10, 14, 17, 18)**
Each has intentional bugs. Practice reading error messages precisely and
fixing only what's broken — no unnecessary refactoring.

**Phase 3 — Exam lab scenarios (Labs 5, 12, 13, 20)**
These most closely mirror the 4-hour exam lab format. Set a timer.
- Lab 05: Refactor without destroying (`moved` blocks)
- Lab 12: Import real AWS resources to zero planned changes
- Lab 13: Two-stack remote state sharing
- Lab 20: Build a complete non-interactive CI pipeline

**Phase 4 — Knowledge gaps (Labs 11, 15, 16, 19)**
Conceptual topics that get tested practically: state exposure, workspaces,
version constraints, and data source edge cases.

---

## Common Exam Traps (Quick Reference)

| Trap | What Actually Happens |
|------|-----------------------|
| `sensitive = true` protects state | NO — state always has plaintext |
| `count` + list removal only removes one item | NO — all items after the removed index are affected |
| `for_each` accepts a `list` | NO — requires `map` or `set`; use `toset()` |
| `file()` renders template variables | NO — only `templatefile()` does variable substitution |
| `terraform fmt` is safe to run in CI | CAUTION — it modifies files; use `fmt -check` in CI |
| Child module can reference root resources directly | NO — values must pass through variables |
| `detailed-exitcode` 1 means changes pending | NO — 2 means changes, 1 means error |
| Import block `id` can be a resource reference | NO — must be a literal string |
| Destroy root config before app config is fine | NO — destroy app first when it reads remote state |
| `moved` block destroys and recreates | NO — it only updates state addresses |

---

## Key Commands Reference

```bash
# Workspace management
terraform workspace new dev
terraform workspace select prod
terraform workspace list

# State surgery
terraform state list
terraform state mv 'old_address' 'new_address'
terraform state rm 'address'
terraform import 'address' 'id'

# Non-interactive CI
terraform init -input=false
terraform plan -input=false -detailed-exitcode -out=tfplan
terraform apply tfplan
terraform fmt -check -recursive

# Debugging
TF_LOG=DEBUG terraform plan
TF_LOG=WARN terraform plan 2>&1 | grep -i warn

# Lock file
terraform init -upgrade
terraform providers lock

# Console (REPL for testing expressions)
terraform console
> [for k, v in var.buckets : k]
> toset(["a", "b", "a"])
```