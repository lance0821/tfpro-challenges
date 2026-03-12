
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
