# Lab 17 — count vs for_each: When to Use Each and Why It Matters

## Difficulty: Hard
## Skills Tested
- Behavioral differences between `count` and `for_each`
- State address changes when list items are inserted/removed
- Converting from `count` to `for_each` without destroying resources
- Using `toset()` and `tomap()` for `for_each` input

## Context
Choosing the wrong meta-argument causes unnecessary resource destruction.
This is one of the most common production Terraform mistakes and a
confirmed exam scenario. You must understand WHY count causes problems
and WHEN for_each is required.

## The Core Problem With count
```
# If you have: count = 3 and list = ["a", "b", "c"]
# Resources are: aws_iam_user.this[0], [1], [2]
#
# If you remove "b" → list becomes ["a", "c"]
# Terraform sees: [0]="a" unchanged, [1]="c" (was "b" → DESTROY+CREATE), [2] deleted
# Result: user "c" gets DESTROYED and RECREATED — not just user "b"
```

## Tasks

### Task 1 — Observe the count problem
Create 3 IAM users using `count` and a list:
```hcl
variable "users" {
  default = ["alice", "bob", "carol"]
}

resource "aws_iam_user" "this" {
  count = length(var.users)
  name  = var.users[count.index]
}
```
Apply. Then remove `"bob"` from the list (leave alice and carol).
Run `terraform plan` — how many users does Terraform plan to destroy?
Which users are affected?

### Task 2 — Fix with for_each
Refactor to use `for_each`:
```hcl
resource "aws_iam_user" "this" {
  for_each = toset(var.users)
  name     = each.value
}
```
Now remove `"bob"` from the set and run plan again. How many users
does Terraform plan to destroy now? Why is this the correct behavior?

### Task 3 — Migrate state from count to for_each
You've refactored the code but the state still has count-based addresses.
You must rename the state entries WITHOUT destroying resources:

```bash
# Old address:   aws_iam_user.this[0]
# New address:   aws_iam_user.this["alice"]
terraform state mv 'aws_iam_user.this[0]' 'aws_iam_user.this["alice"]'
terraform state mv 'aws_iam_user.this[1]' 'aws_iam_user.this["bob"]'
terraform state mv 'aws_iam_user.this[2]' 'aws_iam_user.this["carol"]'
```
After all three moves, run `terraform plan` — it must show 0 changes.

### Task 4 — for_each over a map (more control)
When your items have attributes beyond just a name, use `for_each` over
a map of objects:
```hcl
variable "users" {
  default = {
    alice = { team = "platform", admin = true  }
    bob   = { team = "security", admin = false }
  }
}

resource "aws_iam_user" "this" {
  for_each = var.users
  name     = each.key
  tags     = { Team = each.value.team }
}
```
What is the state address for the alice user?
What happens if you add `carol` to the map?
What happens if you remove `bob`?

### Task 5 — WHEN to still use count
`for_each` is almost always preferred, but `count` is still correct for:
1. Conditional single-resource creation: `count = var.enabled ? 1 : 0`
2. Creating N identical resources (e.g., N identical worker nodes)

Implement both patterns. For pattern 1, show how you reference the
resource: `aws_instance.this[0].id` (requires `[0]` even when count=1).

### Task 6 — BUG: for_each over a list (fails)
```hcl
variable "env_names" {
  default = ["dev", "staging", "prod"]
}

resource "aws_s3_bucket" "envs" {
  for_each = var.env_names   # BUG: for_each requires a map or set, not a list
  bucket   = "myapp-${each.value}"
}
```
Fix this two ways:
1. Using `toset(var.env_names)`
2. Changing the variable type to `set(string)`

Explain the difference between a `list` and a `set` in Terraform.

## Success Criteria
- Task 1 shows count destroys wrong users (you can explain why)
- Task 2 shows for_each only destroys the removed user
- Task 3 state mv results in 0 planned changes
- Task 6 bug identified and fixed both ways
