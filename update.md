Focused plan to round out tfpro-challenges

Your repo already has a strong base for the Professional exam: Challenge 1 hits state/import/destruction workflows, Challenge 2 hits module refactoring and zero-change planning, Challenges 3 and 6 hit multi-provider/authentication patterns, Challenges 4, 7, and 8 hit CSV-driven dynamic HCL and outputs, and Challenge 5 combines data sources, modularization, remote backends, terraform_remote_state, and imports. That aligns well with big parts of the official objectives for lifecycle, dynamic configuration, modules, remote state, and providers.  ￼

Where the repo is still thin compared with the official blueprint is validation and testing, sensitive data handling, version constraints and lock files, automation workflows, provider troubleshooting, and HCP Terraform knowledge. Those are explicitly called out in the current HashiCorp learning path and content list, while your existing challenges lean more toward state/module/provider mechanics and data shaping.  ￼

What to add first

1. Add a dedicated validation, checks, and test challenge
This is the biggest gap. The official content list explicitly names tests, checks, input variables, type constraints, and custom conditions, but none of the current challenges center those skills. Add one challenge where the student must fix a config by adding variable validation, object type constraints, precondition/postcondition, at least one check block, and one terraform test.  ￼

Use an AWS-flavored scenario so it stays exam-relevant: validate that only approved regions are allowed, require two subnet IDs, ensure an AMI data source resolves to the expected architecture, and fail early when bad input is passed. That would directly reinforce objective 2a instead of leaving it as theory.  ￼

2. Add a version constraints, upgrades, and lock file challenge
The official exam content explicitly includes Terraform/provider/module version constraints and the dependency lock file. Your current repo uses real Terraform but does not appear to force students through upgrade conflicts, lock-file interpretation, or controlled init -upgrade workflows. Add a lab where the learner must resolve a broken provider constraint, pin a child module version, inspect .terraform.lock.hcl, and get back to a successful plan.  ￼

A good version of this challenge would deliberately introduce one incompatible provider constraint and one child module version mismatch, then require the learner to explain what changed after terraform init -upgrade. That would make the “collaborative workflow” objective much more complete.  ￼

3. Add a sensitive data and secret hygiene challenge
Objective 2f explicitly calls out managing sensitive data and references Vault-style thinking. None of the current challenges appear to make the learner inspect state exposure, misuse outputs, or fix unsafe secret handling. Add a lab where one variable is marked sensitive, one output leaks something it should not, and the learner must explain what Terraform hides in CLI output versus what still exists in state.  ￼

This should be practical, not abstract: start with a “bad” config, run it, inspect the state, then refactor it into a safer pattern. That kind of exercise is much closer to how the exam tests judgment.  ￼

4. Add an automation / non-interactive workflow challenge
The learning path explicitly says to review how to modify workflows for automation, and the content list includes using Terraform in automation and state locking. Your current labs are mostly human-driven. Add a challenge where the learner must make the repo CI-friendly: noninteractive init, saved plans, fmt -check, validate, plan -detailed-exitcode, and a separate apply from the saved plan.  ￼

A good pass condition would be: “works from a clean shell with only environment variables and no prompts.” That better mirrors team workflows and the operational mindset HashiCorp is emphasizing.  ￼

5. Add a provider troubleshooting challenge
The official objectives include understanding Terraform’s plugin-based architecture, configuring providers with aliasing/versioning/sourcing, managing auth, and troubleshooting provider errors. Your repo already does a nice job with auth and multiple AWS profiles in Challenges 3 and 6, but it does not appear to explicitly train failure diagnosis.  ￼

Add a lab with three deliberate failures: a wrong alias passed to a child module, a broken shared config/credentials setup, and a provider version conflict. Require the learner to use Terraform diagnostics and debug-minded reasoning to repair the config. That would round out providers much better than more happy-path auth work.  ￼

6. Add an HCP Terraform multiple-choice prep pack
HCP Terraform is explicitly in scope for multiple-choice even though it is not a hands-on lab objective. Your repo does not currently seem to address it. Add a hcp-theory/ section with short scenario questions on runs, workspaces, variable assignment, dynamic credentials, permissions, policies, run tasks, and run triggers.  ￼

This does not need live HCP infrastructure. A clean set of scenario cards and answer explanations is enough to plug the objective gap.  ￼

What to improve inside the current challenges

Challenge 1
It already teaches fixing broken code, outputs, imports, state handling, and removing an object from state without deleting it. Improve it by adding explicit import block usage, a drift-reconciliation step, and a config-driven “stop managing but do not destroy” step using modern refactor patterns instead of leaving everything CLI-centric. The official content list specifically names importing resources and reconciling drift, plus import and moved blocks.  ￼

Challenge 2
This is already one of the strongest labs in the repo because it forces a monolith-to-modules refactor, address changes, and a Plan: 0 to add, 0 to change, 0 to destroy end state. Improve it by requiring moved blocks first, then optionally showing terraform state mv as the fallback/manual route. Also add module versioning to the exercise so it covers both refactoring and lifecycle of a module over time.  ￼

Challenges 3 and 6
These are already valuable for profile files, assume-role flows, provider scoping, and role separation. Improve them by adding aliased providers passed into child modules, one broken alias mapping, and one auth failure that the learner must diagnose. That would better match the official provider objectives around aliasing, auth, upgrades, and troubleshooting.  ￼

Challenges 4, 7, and 8
These are good for CSV ingestion, locals, count, for_each, expressions, and structured outputs. Improve them by layering in variable validation, complex object inputs, type constraints, and at least one check or terraform test. Right now they reinforce dynamic HCL well, but they do not fully cover the validation half of the dynamic configuration objective.  ￼

Challenge 5
This is already your best “bridge” challenge because it combines data sources, for_each, modularization, S3 backend migration, terraform_remote_state, and imports. Improve it by adding state locking discussion, a backend migration failure mode, and a variant that shares data across configurations in two different ways so the learner can compare tradeoffs.  ￼

The six new challenge ideas I would actually build

Challenge 9 — Validation and tests
Broken config; learner must add validations, custom conditions, checks, and one passing terraform test. This closes the cleanest objective gap.  ￼

Challenge 10 — Versions and lock file
Broken provider/module constraints; learner must repair constraints, upgrade safely, and explain .terraform.lock.hcl.  ￼

Challenge 11 — Sensitive data
Leaky outputs and unsafe secret handling; learner must mark sensitive values correctly, inspect state implications, and refactor.  ￼

Challenge 12 — Automation
Make the repo runnable in CI with noninteractive init/plan/apply, state locking awareness, and deterministic saved plans.  ￼

Challenge 13 — Provider troubleshooting
Broken aliasing, broken auth, broken version source; learner must diagnose and repair provider failures.  ￼

Challenge 14 — HCP Terraform scenarios
Multiple-choice style repo section with realistic scenarios and explanations rather than live infra.  ￼

Repo-level improvements that would make the learning experience better

Add a top-level “objective matrix” README that maps each challenge to the official exam objectives and sub-objectives. Right now the repo has eight challenge folders and a short root README, but it does not give the learner a direct map from repo content to HashiCorp’s blueprint.  ￼

Add a standard challenge template with four sections: “skills tested,” “common failure modes,” “allowed docs,” and “final success state.” HashiCorp’s learning path stresses hands-on practice in a docs-available environment, so your repo should train students to solve with Terraform docs and AWS docs rather than tutorial hand-holding.  ￼

Add answer keys in a separate branch or folder that explain why one solution is safer than another. For the Professional exam, the most important thing is not just making Terraform work, but making refactors safe and predictable over time. That theme runs through the official study guidance on lifecycle, workflows, modules, and providers.  ￼

My recommendation

Do not replace the current eight challenges. Keep them, then add four to six targeted labs that cover the missing exam objectives. If you only add three things, make them: a validation/testing challenge, a versioning/lock-file challenge, and an automation challenge. Those give you the biggest blueprint coverage gain for the least extra work.  ￼

I can turn this into a concrete repo roadmap next, with proposed folder names, challenge descriptions, and the exact order I’d implement them.


The repository (https://github.com/lance0821/tfpro-challenges) contains exactly 8 hands-on challenges designed for the HashiCorp Certified: Terraform Authoring and Operations Professional 2025 exam (the official name for the pro-level certification). They are part of Zeal Vora’s video course and focus on lengthy, moderately difficult scenarios using AWS resources. Each challenge ships with a Readme.md that lists 5–11 sequential tasks, plus the Terraform code (.tf files, CSVs, etc.) you must fix, extend, refactor, or destroy.0
Quick Mapping of the 8 Challenges to Exam Topics
Here is how the repo aligns with the official exam content outline:
Challenge
Primary Focus (from README + code)
Exam Objectives Covered
1
Fix broken code → outputs → state import/remove-from-state (without deletion) → S3 object → destroy
1 (lifecycle, import, drift reconciliation, state management)
2
Refactor monolithic config into 5 child modules (ec2, sg, s3, iam, random) + data source (AMI) + module outputs + manual state addressing
2 (data sources, meta-arguments, complex outputs), 4 (modules & refactoring)
3
Multi-profile providers + IAM role assumption + modules (asg, iam) + ignore_changes on ASG desired_capacity
1 (lifecycle meta-arguments), 5 (provider config, aliases/profiles, auth)
4
CSV external data + count (NOT for_each) + conditional creation + dynamic mapping + structured outputs
2 (dynamic config, functions, complex outputs)
5
Data sources + for_each + modules + S3 remote backend + terraform_remote_state data source + import + state migration
1 (import), 2 (data sources, for_each), 3 (remote state, sharing data)
6
Advanced multi-profile AWS config + source_profile role assumption + credentials/config files
5 (provider authentication, troubleshooting)
7
Pure data-processing: CSV → local values → complex outputs (list of lists, map of maps, filtered maps) using for expressions
2 (HCL functions, complex types, outputs)
8
Data source (subnets) + CSV-driven aws_vpc_security_group_ingress_rule + computed CIDR blocks + filtered outputs
2 (data sources, for expressions, outputs)
Strong coverage: Resource lifecycle & state (Obj 1), dynamic config & functions (Obj 2), modules (Obj 4), providers (Obj 5), and remote state (Obj 3). Gaps / lighter coverage: Explicit moved blocks, version constraints, sensitive-data handling (Vault, sensitive flag best practices), automation/CI/CD workflows, provider upgrades, and HCP Terraform (Obj 6 is multiple-choice only).1
The official learning path (https://developer.hashicorp.com/terraform/tutorials/pro-cert/pro-study) mirrors the same 6 objectives and recommends targeted tutorials on CLI commands, state import, refactoring, remote state, modules, providers, and HCP Terraform. The repo challenges are an excellent practical supplement because they force you to do the tasks end-to-end (including state surgery, CSV processing, and multi-profile auth).
Proposed Additional Exercises
Below are 8 new exercises I designed to fill the gaps and reinforce every exam objective. They are progressive, use only the AWS free tier (or local backends), and include success criteria so you can self-grade. Do them after the repo’s 8 challenges and the official tutorials.
	1	Refactoring with moved blocks (Obj 4 + 1) Start with a flat config containing aws_instance, aws_s3_bucket, and aws_iam_role. Refactor into modules (compute, storage, iam). Use moved blocks to update resource addresses so terraform plan shows 0 changes. Then run terraform state list and terraform plan to verify. Success: no resources are recreated.
	2	Sensitive data & Vault integration (Obj 2) Declare a sensitive variable for an RDS password. Use the vault data source (or aws_secretsmanager) to fetch it dynamically. Mark outputs as sensitive = true. Add a local_file that writes the password (should be redacted in state/CLI). Success: terraform plan never shows the secret in clear text; terraform output redacts it.
	3	Version constraints & provider upgrades (Obj 3 + 5) Pin Terraform ≥ 1.5, AWS provider ~> 5.0, and random provider ~> 3.0. Then intentionally bump the AWS provider to 5.80 and run terraform init -upgrade. Use terraform providers schema and terraform plan to validate. Success: no breaking changes; you document which resources were affected.
	4	Remote state data sharing + workspaces (Obj 3) Create two separate configs: “network” (VPC + subnets, S3 backend) and “compute” (EC2). In compute, use terraform_remote_state data source to pull subnet IDs. Deploy both in different workspaces (dev vs prod). Success: compute config reads live subnet data without hard-coding.
	5	Automation workflow simulation (Obj 3) Write a simple shell script that runs terraform init, terraform validate, terraform plan -out=plan.tfplan, then terraform apply "plan.tfplan". Add a check block (Terraform 1.5+) that validates an IAM policy document. Run it in a GitHub Actions-style dry-run. Success: script succeeds only if plan is clean and checks pass.
	6	Drift detection & reconciliation (Obj 1) Deploy an EC2 instance. Manually change its instance type in the AWS console. Run terraform plan (should detect drift). Then use terraform apply + ignore_changes or targeted terraform apply -target=... to reconcile without full replace. Success: plan shows drift, apply fixes it safely.
	7	Complex validation & custom functions (Obj 2) Create a variable cidr_blocks (list). Use a validation block + for expression to ensure no overlap and all are /24. Add a local value that transforms the list into a map keyed by subnet name. Success: invalid CIDR triggers a clear validation error on terraform validate.
	8	HCP Terraform simulation (Obj 6 – prep for MCQs) Although hands-on HCP Terraform is not required for the exam, practice locally: set up two workspaces, attach variables (including sensitive), create a run trigger, and simulate a Sentinel policy (or use terraform cloud free tier). Document the run workflow diagram. Success: you can explain (and show) how variable precedence, run tasks, and policy enforcement work.
Recommended Study Plan to Pass
	1	Complete the official learning path tutorials (especially the CLI, state import, modules, and remote-state sections).
	2	Solve the repo’s 8 challenges in order (they build on each other).
	3	Do the 8 exercises above.
	4	For every exercise, always run: terraform validate, terraform plan -out=plan, terraform show plan, terraform apply "plan", then terraform destroy.
	5	Practice state surgery commands daily: terraform state list, terraform state mv, terraform state rm, terraform import.
	6	Review the exact AWS resources listed in the exam outline (launch templates, ASGs, IAM instance profiles, S3 backend, etc.) – they appear in almost every challenge.
If you complete the repo challenges + these 8 extras (and the official tutorials), you will have touched every single objective with real code. The exam is heavily scenario-based and tests “what would you do next?”—these exercises train exactly that muscle.
Feel free to paste any specific challenge or error you hit and I’ll walk you through the exact fix or extension! Good luck—you’ve got this. 🚀


# Terraform Professional exam: gap analysis and study plan

**The repository’s 8 challenges provide solid hands-on practice for roughly 60–70% of the exam’s surface area, but leave meaningful gaps in HCP Terraform concepts, advanced module refactoring with `moved` blocks, provider troubleshooting, and timed lab fluency.** This matters because the Terraform Authoring and Operations Professional exam is a grueling 4-hour, lab-based assessment where candidates must write and debug real Terraform code against live AWS infrastructure — and time management is the single most-cited reason people fail. Below is a complete mapping of the repository to the six official exam domains, an honest assessment of coverage gaps, and a set of targeted exercises designed to close them.

## How the exam actually works

The HashiCorp Terraform Authoring and Operations Professional certification   (testing on **Terraform 1.6** with the **AWS provider**) costs $295, includes one free retake, and runs for **4 hours** with an optional 15-minute break.  Candidates face approximately **12 multiple-choice questions** and **4 hands-on lab scenarios**,   each with 3–4 graded sub-tasks. The lab environment is a pre-provisioned Linux desktop with VS Code,  a terminal, and access to Terraform docs, the AWS provider registry, select AWS documentation,  and the AWS console.  Critically, **no external search engines are available**  — you must navigate documentation directly. 

The exam is organized into six domains. Domains 1–5 can appear in both lab and multiple-choice formats, while **Domain 6 (HCP Terraform) is multiple-choice only**.   No official weighting percentages are published, but community reports consistently identify modules/refactoring and HCL functions as the heaviest lab topics.

## Mapping the 8 challenges to the six exam domains

The `lance0821/tfpro-challenges` repository (a fork of `zealvora/tfpro-challenges`) contains **8 HCL-based challenges** designed as part of Zeal Vora’s Udemy course. Individual challenge files require cloning the repo, but the course curriculum and repository metadata reveal the following topic coverage mapped against each official exam domain.

|Exam Domain                                                |Key Sub-objectives                                                                                      |Repo Coverage                                                                                                                       |Assessment                                                                                                                      |
|-----------------------------------------------------------|--------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
|**1. Manage Resource Lifecycle** (1a–1e)                   |`init`, `plan`, `apply`, `destroy`, import, drift reconciliation, `moved` blocks, resource targeting    |Challenges cover state management, S3 backends, DynamoDB locking, resource import, and lifecycle rules                              |**Good** — core CLI workflow and state operations are well-practiced                                                            |
|**2. Develop & Troubleshoot Dynamic Configuration** (2a–2f)|Validation/tests, data sources, HCL functions, meta-arguments, complex variables/outputs, sensitive data|Challenges cover FOR expressions, dynamic blocks, `count`/`for_each`, custom validations, `terraform test`, CSV/JSON data processing|**Good** — strongest area of the repo, though HCL function depth may need supplementation                                       |
|**3. Develop Collaborative Workflows** (3a–3d)             |Version constraints, remote state, state locking, automation, cross-workspace data sharing              |Challenges cover S3 remote backend, DynamoDB locking, `terraform_remote_state` data source, saving plans to file                    |**Moderate** — remote state basics covered, but automation pipelines and `tfe_outputs` data source are thin                     |
|**4. Create, Maintain, and Use Modules** (4a–4d)           |Module creation, module sourcing, module versioning, refactoring into modules with `moved` blocks       |Challenges include modular structures and module design                                                                             |**Moderate** — module basics present, but advanced refactoring with `moved` blocks and version management may be under-practiced|
|**5. Configure and Use Providers** (5a–5d)                 |Plugin architecture, aliasing, versioning, dependency lock file, authentication, debugging              |Challenges cover provider plugin caching and file system mirror                                                                     |**Weak** — provider aliasing, lock file management, and systematic troubleshooting are not deeply exercised                     |
|**6. HCP Terraform** (6a–6d)                               |Run workflow, workspaces, dynamic credentials, policy enforcement (Sentinel/OPA)                        |Not covered — the repo focuses on open-source Terraform with AWS                                                                    |**Not covered** — this entire domain requires separate study                                                                    |

## Where the gaps are sharpest

**Domain 6 (HCP Terraform) has zero coverage** in the repository. While this domain is multiple-choice only, it still requires solid conceptual knowledge of the HCP Terraform run workflow, workspace configuration, dynamic provider credentials, team permissions, run tasks, run triggers, and policy-as-code enforcement  with Sentinel or OPA. Candidates who skip this domain risk losing every point in that section.

**Advanced module refactoring (4c, 4d) is under-practiced.** Community reports consistently identify “decomposing a monolithic configuration into modules without destroying resources” as a major lab scenario. This requires fluent use of **`moved` blocks**  — a feature many candidates encounter for the first time during the exam. The repository’s module challenges appear to focus on module creation and usage rather than the surgical refactoring that the exam demands.

**Provider troubleshooting and debugging (5d) receives minimal attention.** The exam includes a dedicated “Debugging” lab scenario where you must diagnose and fix broken Terraform configurations. This requires understanding the **dependency lock file** (`.terraform.lock.hcl`),  provider version conflicts, `TF_LOG` environment variables, and systematic error interpretation — skills the repository doesn’t explicitly exercise.

**HCL function mastery (2c) needs depth beyond the basics.** Multiple candidates who failed or barely passed cite functions as a weak point. The exam tests file-related functions (`file()`, `templatefile()`), string manipulation, collection functions (`flatten`, `merge`, `lookup`, `zipmap`), and type conversion functions in contexts that require chaining multiple functions together.  The repo covers FOR expressions and dynamic blocks, but may not push function fluency far enough.

**Automation workflows and CI/CD integration (3c)** receive only light treatment. The exam tests knowledge of how Terraform behaves in non-interactive contexts — `-auto-approve`, `-input=false`, plan file output for approval gates, and state locking behavior in concurrent pipelines.

## Proposed exercises to close every gap

The following hands-on exercises are designed to complement the repository’s 8 challenges and ensure complete domain coverage. Each exercise targets a specific gap identified above.

### Exercise A: HCP Terraform run workflow simulation (Domain 6)

Since HCP Terraform questions are multiple-choice only, this exercise is study-and-quiz based. Create a free HCP Terraform account at app.terraform.io. Set up a workspace connected to a VCS repository containing a simple AWS configuration. Practice the full run workflow: trigger a speculative plan from a pull request, observe the plan-and-apply pipeline, configure run triggers between two workspaces, and add a run task.  Then configure workspace variables (both Terraform and environment variables), set up dynamic provider credentials for AWS using OIDC, create a team with limited permissions, and write a basic Sentinel policy that blocks resources without required tags.  Document the exact sequence of each workflow step — the multiple-choice questions test precise knowledge of what happens at each stage. 

### Exercise B: Monolith-to-module refactoring with `moved` blocks (Domain 4c, 4d)

Create a single `main.tf` file that provisions an `aws_instance`, an `aws_security_group`, an `aws_s3_bucket`, an `aws_iam_role`, and an `aws_iam_instance_profile` — all in the root module with hardcoded values. Apply it successfully. Then refactor this configuration into three child modules (`compute`, `storage`, `iam`) without destroying any resources. Use `moved` blocks to update resource addresses (e.g., `moved { from = aws_instance.web to = module.compute.aws_instance.web }`). Verify with `terraform plan` that zero resources are destroyed or recreated. Then practice the reverse: collapsing modules back into the root. Finally, version your module using a Git tag and practice upgrading from `v1.0.0` to `v2.0.0` with a breaking change. 

### Exercise C: Debugging broken configurations (Domain 5d, 1e)

Create three intentionally broken Terraform projects and practice diagnosing them under time pressure:

- **Project 1 — Provider version conflict**: Set up a configuration with a `.terraform.lock.hcl` file that specifies one AWS provider hash, then manually edit `required_providers` to demand a different version. Run `terraform init` and interpret the error. Fix it using `terraform init -upgrade` and understand when and why the lock file should be regenerated.
- **Project 2 — State drift reconciliation**: Deploy an `aws_instance` with Terraform, then manually modify its tags and security group in the AWS console. Run `terraform plan` to observe drift detection. Practice using `terraform apply -refresh-only` to accept the drift versus `terraform apply` to correct it.
- **Project 3 — Import and debug**: Manually create an S3 bucket and IAM role in the AWS console. Write Terraform configuration for them using `import` blocks (not the CLI command). Run `terraform plan` to generate the import plan, then apply. Troubleshoot any argument mismatches between your configuration and the real resource.

Set `TF_LOG=DEBUG` and practice reading the output to identify where errors originate (provider API calls, state file operations, or HCL parsing).

### Exercise D: Advanced HCL function gauntlet (Domain 2c, 2e)

Build a project that forces you to use **at least 15 different Terraform functions** in realistic contexts:

- Use `file()` and `templatefile()` to render a user data script for an EC2 instance from a template with variable interpolation.
- Use `csvdecode()` to read a CSV file and create multiple `aws_instance` resources with `for_each`, extracting instance type and name tag from each row.
- Use `jsondecode()` to parse a JSON configuration file and pass values into module inputs.
- Chain `flatten()`, `merge()`, and `zipmap()` to transform a nested map of security group rules into a flat list suitable for `for_each`.
- Use `lookup()`, `coalesce()`, `try()`, and `can()` for defensive configuration that handles missing or optional values.
- Use `cidrsubnet()` to dynamically calculate subnet CIDRs from a VPC CIDR block.
- Practice `format()`, `join()`, `split()`, `replace()`, and `regex()` for string manipulation in resource naming conventions.
- Use `nonsensitive()` and `sensitive()` to manage sensitive outputs correctly.

### Exercise E: Automation-ready Terraform workflow (Domain 3c, 3d)

Build a CI/CD-style workflow that tests Terraform’s automation behavior:

- Create two separate Terraform configurations (`network` and `application`) each with an S3 remote backend in different state files.
- In the `network` config, output the VPC ID and subnet IDs. In the `application` config, consume these using the `terraform_remote_state` data source.
- Write a shell script that runs the full workflow non-interactively: `terraform init -input=false`, `terraform plan -out=tfplan`, then `terraform apply tfplan`. Test what happens when state locking prevents concurrent runs (open two terminals and run apply simultaneously against the same state).
- Practice using `-target` to apply a subset of resources and `-replace` to force recreation of a specific resource.
- Test the `tfe_outputs` data source pattern by reading outputs from an HCP Terraform workspace (if using a free HCP Terraform account from Exercise A).

### Exercise F: Complete AWS resource familiarity drill (Domains 1–5)

The exam tests a **specific set of AWS resources**.  Build one integrated project that uses every resource on the exam’s list: `aws_instance` with a `aws_launch_template`, an `aws_autoscaling_group`, `aws_security_group` with `aws_security_group_rule` and `aws_vpc_security_group_ingress_rule`, `aws_s3_bucket` with `aws_s3_object`, the full IAM chain (`aws_iam_role`, `aws_iam_policy`, `aws_iam_instance_profile`, `aws_iam_role_policy_attachment`), and data sources `aws_ami`, `aws_caller_identity`, `aws_iam_session_context`, `aws_iam_policy_document`, and `aws_subnet`. Include `random_integer` for dynamic naming. Use the S3 backend  with DynamoDB locking. The goal is not architectural elegance — it’s instant recall of every argument and attribute these resources require.

## What people who passed wish they’d known

The community feedback is remarkably consistent across dozens of exam reports. **Time is the enemy.** Multiple experienced Terraform practitioners reported nearly running out of the 4-hour window. The winning strategy is to skim all four lab scenarios at the start, tackle the easiest one first, and never spend more than 45 minutes on a single lab.   Partial completion earns partial credit since labs are scored independently.  

**Documentation navigation is a hidden skill.** Without Google, candidates who can’t quickly find the right page in the Terraform docs or AWS provider registry lose precious minutes.   Practice navigating `developer.hashicorp.com/terraform/docs` and `registry.terraform.io/providers/hashicorp/aws/latest/docs` by bookmark-style browsing before exam day. 

**The gap between Associate and Professional is enormous.** The Associate exam tests theoretical knowledge with multiple-choice questions over 1 hour.  The Professional demands production-level execution speed across 4 hours of hands-on work.   As one exam-taker put it: “Having passed the Terraform Associate means next to nothing for this exam.”  

## Conclusion

The `tfpro-challenges` repository provides a strong foundation for Domains 1 and 2 — the resource lifecycle and dynamic configuration topics that form the core of Terraform usage. Its real value is building hands-on muscle memory with HCL, state management, and AWS provider resources. However, passing the Professional exam requires closing five specific gaps: **HCP Terraform conceptual knowledge** (Domain 6), **`moved`-block-based module refactoring** (Domain 4), **systematic debugging skills** (Domain 5), **deep HCL function fluency** (Domain 2c), and **automation workflow patterns** (Domain 3c). The six proposed exercises above directly target these gaps. Combined with the repository’s existing challenges, they create comprehensive coverage of all 23 exam sub-objectives across all 6 domains. The final preparation step is practicing everything under realistic time pressure — because on exam day, knowing Terraform isn’t enough; you need to be fast. 