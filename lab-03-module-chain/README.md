# Lab 03 — Module Composition (Three-Module Chain)

## Skills Tested
- Passing outputs from one child module into another via root
- Module dependency ordering
- Output naming and variable naming consistency

## Context
You have three modules: `random`, `iam`, and `ec2`. The IAM module needs
the random pet name. The EC2 module needs the IAM instance profile name.
You must wire all three together through the root module.

## Module Descriptions

### modules/random
- Creates a `random_pet` resource
- **Output**: `pet_name` = the generated id

### modules/iam
- Creates `aws_iam_role` and `aws_iam_instance_profile`
- **Input**: `name_prefix` (string) — used in resource names
- **Output**: `instance_profile_name`

### modules/ec2
- Creates one `aws_instance`
- **Input**: `instance_profile` (string)
- **Input**: `name_tag` (string)

## Tasks

### Task 1 — Build the random module
Create `modules/random/main.tf` with a `random_pet` resource and
`modules/random/outputs.tf` exporting `pet_name`.

### Task 2 — Build the IAM module
Create the IAM module files. The role must allow EC2 to assume it.
Export `instance_profile_name` from `outputs.tf`.
Accept `name_prefix` as a variable.

### Task 3 — Build the EC2 module
Create the EC2 module. Use `var.instance_profile` in the `iam_instance_profile`
argument — NOT a hardcoded resource reference.

### Task 4 — Wire them in root
In the root `main.tf`, call all three modules. Pass:
- `module.random.pet_name` → `module.iam.name_prefix`
- `module.iam.instance_profile_name` → `module.ec2.instance_profile`
- `module.random.pet_name` → `module.ec2.name_tag`

### Task 5 — Verify the chain
Run `terraform plan` and confirm no errors. The EC2 instance name tag
and IAM profile name should both contain the random pet name.

## Success Criteria
- No direct resource references cross module boundaries
- Root is the only place modules are called
- `terraform plan` succeeds without errors
