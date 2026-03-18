# Lab 02 — Dynamic Blocks

## Skills Tested
- `dynamic` block syntax
- Iterating over a variable with `for_each` inside a dynamic block
- Conditional dynamic blocks using `for` expressions

## Context
Instead of hardcoding each ingress/egress rule in a security group,
you want to drive all rules from a variable. This is a common real-world pattern.

## Tasks

### Task 1 — Define the rules variable
In `variables.tf`, create a variable `ingress_rules` of type:
```hcl
list(object({
  from_port   = number
  to_port     = number
  protocol    = string
  cidr_blocks = list(string)
  description = string
}))
```
Add a default with at least 3 rules (e.g., 22, 80, 443).

### Task 2 — Create the security group with a dynamic block
Use a `dynamic "ingress"` block inside `aws_security_group` to loop
over `var.ingress_rules`. Each attribute inside the block must reference
`ingress.value.<attribute_name>`.

### Task 3 — Add a dynamic egress block
Add a single egress rule that allows all outbound traffic (0.0.0.0/0).
Do this with a `dynamic "egress"` block driven by a local value.

### Task 4 — Filter rules conditionally
Add a local value that filters `var.ingress_rules` to only those with
`from_port < 1024`. Name it `privileged_rules`. Output it.

## Success Criteria
- Adding a new object to `var.ingress_rules` adds exactly one new rule
- Removing an entry removes only that rule — no other resources change
- `terraform plan` shows no changes after a clean apply
