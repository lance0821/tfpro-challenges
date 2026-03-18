# Lab 04 — Provider Aliases: Multi-Region Deployment

## Skills Tested
- Defining multiple provider configurations with `alias`
- Passing aliased providers to child modules via `providers` map
- `configuration_aliases` in child module `required_providers`

## Context
Your company requires certain resources to exist in both us-east-1 AND
us-west-2 for redundancy. You'll use provider aliases to manage both
regions from one root configuration.

## Tasks

### Task 1 — Define two provider blocks in root
Create a default provider for `us-east-1` and an aliased provider
`aws.west` for `us-west-2`.

### Task 2 — Build a child module that accepts an aliased provider
Create `modules/bucket/main.tf` that:
- Declares `configuration_aliases = [aws.regional]` in `required_providers`
- Creates an `aws_s3_bucket` using `provider = aws.regional`
- Accepts a variable `bucket_suffix` (string)
- Outputs the bucket name

### Task 3 — Call the module twice from root
In root, call `module "east_bucket"` and `module "west_bucket"`, each
pointing to `./modules/bucket`. Pass:
- `east`: `providers = { aws.regional = aws }` (default provider)
- `west`: `providers = { aws.regional = aws.west }` (aliased provider)

### Task 4 — BUG FIX (intentional error below)
The `providers` map below has the wrong key. Fix it.
```hcl
module "west_bucket" {
  source        = "./modules/bucket"
  bucket_suffix = "west"
  providers = {
    aws.wrong = aws.west   # BUG: wrong key name
  }
}
```

### Task 5 — Output both bucket names
Create outputs in root showing the bucket name from each module call.

## Success Criteria
- Two buckets created — one in each region
- Each module call uses a different provider configuration
- `terraform plan` succeeds with no errors
