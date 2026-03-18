# Lab 05 — Refactoring with `moved` Blocks

## Skills Tested
- `moved` block syntax
- Refactoring flat configurations into modules without destroying resources
- Verifying zero-change plans after state address updates

## Context
You have an existing flat configuration with an EC2 instance and security
group in root. Your task is to move these into child modules WITHOUT
destroying and recreating the real AWS resources.

## Starting State
The `main.tf` already has working resources at:
- `aws_instance.web`
- `aws_security_group.web_sg`

## Tasks

### Task 1 — Apply the flat config first
Run `terraform apply` to create the real resources. Note the resource
addresses in `terraform state list`.

### Task 2 — Create child modules
Create `modules/compute/main.tf` with the `aws_instance` resource.
Create `modules/network/main.tf` with the `aws_security_group` resource.
Move the code from root into each module. Add variables as needed.

### Task 3 — Update root to call the modules
Replace the flat resources in root with module calls:
```hcl
module "compute" { source = "./modules/compute" ... }
module "network" { source = "./modules/network" ... }
```

### Task 4 — Add moved blocks
In root, add `moved` blocks to tell Terraform the resources moved:
```hcl
moved {
  from = aws_instance.web
  to   = module.compute.aws_instance.web
}
moved {
  from = aws_security_group.web_sg
  to   = module.network.aws_security_group.web_sg
}
```

### Task 5 — Verify zero changes
Run `terraform plan`. The plan must show:
```
Plan: 0 to add, 0 to change, 0 to destroy.
```
If it shows replacements, your resource names inside the modules
don't match the `moved` block targets.

## Common Mistakes
- Resource name inside module doesn't match the `to` address
- Forgetting to add variables to the child module for values that
  were previously hardcoded in root

## Success Criteria
- `terraform plan` shows 0 changes after the refactor
- `terraform state list` shows new module-prefixed addresses
