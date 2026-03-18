# Lab 09 — Locals and Complex For Expressions

## Skills Tested
- `locals` block for intermediate values
- `for` expressions to transform collections
- Filtering with `if` inside `for` expressions
- Building maps from lists

## Context
Raw input data rarely has the exact shape your resources need.
Locals with `for` expressions let you reshape data without repeating
yourself or using complex inline expressions.

## Tasks

### Task 1 — Flatten a list with a local
Given this variable:
```hcl
variable "teams" {
  default = {
    "platform" = ["alice", "bob"]
    "security" = ["carol", "dave", "eve"]
  }
}
```
Create a local `all_users` that produces a flat list of all users
across all teams: `["alice", "bob", "carol", "dave", "eve"]`.
Hint: use `flatten([for team, users in var.teams : users])`.

### Task 2 — Build a map from a list
Create a local that transforms a list of subnet IDs into a map
keyed by an index:
```hcl
# Input:  ["subnet-aaa", "subnet-bbb", "subnet-ccc"]
# Output: { "0" = "subnet-aaa", "1" = "subnet-bbb", "2" = "subnet-ccc" }
```
Hint: `{ for i, v in var.subnet_ids : tostring(i) => v }`

### Task 3 — Filter and transform
Given a list of EC2 instances (objects with `name`, `env`, `type`),
create a local that returns only production instances, transformed
into a map keyed by name. Use `if` inside the `for` expression.

### Task 4 — Invert a map
Given `{ "alice" = "platform", "bob" = "platform", "carol" = "security" }`,
create a local that groups users by team:
```hcl
# Output: { "platform" = ["alice", "bob"], "security" = ["carol"] }
```
This requires a two-step local (first group keys, then build lists).

## Success Criteria
- All locals are defined without errors (`terraform validate`)
- Each local has an output value so you can verify with `terraform console`
- No hardcoding — all transformations work on the raw input variables
