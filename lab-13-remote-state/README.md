# Lab 13 — terraform_remote_state: Two-Stack Cross-Config Data Sharing

## Difficulty: Hard
## Skills Tested
- S3 backend configuration
- `terraform_remote_state` data source
- Cross-configuration output consumption
- Backend key naming strategy
- State locking awareness

## Context
This is the exact pattern tested in the exam's remote state lab scenario.
Two completely separate Terraform configurations ("stacks") must share
data. The `network` stack owns the VPC/subnets. The `app` stack owns
the EC2 instance — but needs the VPC/subnet IDs from `network`.
The stacks have SEPARATE state files and are run independently.

## Directory Structure
```
lab-13/
├── network/
│   ├── main.tf       (creates VPC, subnets)
│   ├── outputs.tf    (exports vpc_id, subnet_ids)
│   └── backend.tf    (S3 backend, key = lab13/network.tfstate)
└── app/
    ├── main.tf       (creates EC2 instance)
    ├── data.tf       (terraform_remote_state source)
    └── backend.tf    (S3 backend, key = lab13/app.tfstate)
```

## Tasks

### Task 1 — Configure the network stack
In `network/backend.tf`, configure an S3 backend. You must create this
bucket manually first (Terraform cannot create its own backend bucket).
Use key `"lab13/network.tfstate"`.

In `network/main.tf`, create:
- `aws_vpc` with CIDR `10.13.0.0/16`
- Two `aws_subnet` resources in different AZs

In `network/outputs.tf`, export:
- `vpc_id`
- `subnet_ids` as a list

Apply the network stack: `cd network && terraform init && terraform apply`

### Task 2 — Configure the app stack's remote state data source
In `app/data.tf`, add:
```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "<your-bucket>"
    key    = "lab13/network.tfstate"
    region = "us-east-1"
  }
}
```
Reference outputs as:
`data.terraform_remote_state.network.outputs.vpc_id`

### Task 3 — Use the remote state in the EC2 instance
In `app/main.tf`, create an `aws_instance` that:
- Uses the VPC from remote state for its security group
- Uses the first subnet from remote state as `subnet_id`
- NEVER hardcodes the VPC ID or subnet ID

### Task 4 — EXAM TRAP: Destruction order
Why must you destroy the `app` stack BEFORE the `network` stack?
What happens to the app stack's remote state data source if the
network stack's state file is deleted first?

### Task 5 — BUG: Fix the broken remote state reference
```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.state_bucket   # BUG: why can't this be a variable?
    key    = "lab13/network.tfstate"
    region = "us-east-1"
  }
}
```

### Task 6 — State locking
While running `terraform apply` in the app stack, simulate a concurrent
apply by opening a second terminal and running apply again against the
same state. What error do you see? What is the lock ID format?

## Success Criteria
- Network stack deployed, outputs visible via `terraform output`
- App stack references network outputs without hardcoding
- `terraform plan` in app stack shows 0 changes after clean apply
- You can answer the destruction order question
