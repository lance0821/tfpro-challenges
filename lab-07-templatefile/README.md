# Lab 07 — templatefile() for EC2 User Data

## Skills Tested
- `templatefile()` function
- Passing variables into templates
- `file()` vs `templatefile()` distinction
- User data on EC2 instances

## Context
Hardcoding user data scripts directly in Terraform is messy.
`templatefile()` lets you keep the script in a `.tpl` file and
inject Terraform variables into it.

## Tasks

### Task 1 — Create the template file
Create `templates/userdata.sh.tpl` with content like:
```bash
#!/bin/bash
echo "Hello from ${instance_name}" > /tmp/greeting.txt
apt-get update -y
echo "Environment: ${environment}" >> /tmp/greeting.txt
```
The `${variable}` syntax inside `.tpl` files is Terraform's template syntax.

### Task 2 — Use templatefile() in your EC2 resource
In `main.tf`, use `templatefile()` to render the template:
```hcl
user_data = templatefile("${path.module}/templates/userdata.sh.tpl", {
  instance_name = var.instance_name
  environment   = var.environment
})
```

### Task 3 — What's the difference?
Explain when you would use `file()` versus `templatefile()`.
Try using `file()` with the same `.tpl` file — what happens to the
`${variable}` placeholders?

### Task 4 — Add a list to the template
Modify the template to loop over a list of packages to install:
```bash
%{ for pkg in packages ~}
apt-get install -y ${pkg}
%{ endfor ~}
```
Pass `packages = ["nginx", "curl", "jq"]` from Terraform.

## Success Criteria
- `terraform plan` shows user_data computed correctly
- Running `terraform show` after apply shows rendered user data
- The `%{ for }` loop in the template installs all packages
