# Lab 11 — Data Sources: Cross-Stack Lookups

## Difficulty: Hard
## Skills Tested
- `data` source filtering with multiple filters
- Using data sources to look up resources created outside Terraform
- `for_each` over data source results
- Understanding the difference between data and resource blocks at plan time

## Context
Your team has existing AWS infrastructure (VPC, subnets, AMI) that was
NOT created by your Terraform config. You must look it up dynamically
rather than hardcoding IDs. One wrong filter and you silently get the
wrong resource — or an error at plan time.

## Tasks

### Task 1 — Look up an existing VPC by tag
Write a `data "aws_vpc"` block that finds a VPC by its `Name` tag.
Do NOT hardcode the VPC ID. Use a `filter` block:
```hcl
filter {
  name   = "tag:Name"
  values = ["your-vpc-name"]
}
```
Output the VPC's `cidr_block` and `id`.

**Exam trap**: What happens if your filter matches MORE than one VPC?
What happens if it matches zero?

### Task 2 — Look up all subnets in that VPC
Use `data "aws_subnets"` (plural) to find all subnets belonging to
the VPC you found in Task 1. Filter by `vpc-id`. Output the list of IDs.

Then use `data "aws_subnet"` (singular, with `for_each`) to fetch
full details of each subnet. Output a map of `subnet_id => availability_zone`.

### Task 3 — Look up the latest Amazon Linux 2023 AMI
Write an `aws_ami` data source that finds the most recent AL2023 AMI.
Requirements:
- Owner: `"amazon"`
- Architecture: `x86_64`
- Virtualization: `hvm`
- Name pattern: `al2023-ami-*`
- `most_recent = true`

**Exam trap**: What happens if you omit `most_recent = true`?

### Task 4 — BUG: The data source below returns the wrong AMI.
Identify all bugs and fix them:
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = "099720109477"   # BUG 1

  filter {
    name   = "name"
    values = "ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"  # BUG 2
  }

  filter {
    name   = "virtualization_type"   # BUG 3
    values = ["hvm"]
  }
}
```

### Task 5 — Chain data source into resource
Use the AMI from Task 3 as the `ami` argument in an `aws_instance`.
Use the first subnet from Task 2 as `subnet_id`.
Never hardcode either value.

## Success Criteria
- `terraform plan` resolves all data sources without errors
- Changing the VPC name tag variable automatically finds the right subnets
- No AMI IDs or subnet IDs are hardcoded anywhere
- You can explain the 3 bugs from Task 4
