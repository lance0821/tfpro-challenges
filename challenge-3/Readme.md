
## Challenge 3

This challenge focuses on implementing a multi-provider configuration in Terraform Modules using AWS services. 

### Base Task

The following resource code is configured  in the `base-folder`:

| Resource Code | Description | 
| :---        |    :----:   | 
| `EC2FullAccess` IAM Role  | Provides Full Access to EC2 service.      | 
| `IAMFullAccess` IAM Role | Provides Full Access to S3 service.   | 
| `kplabs-challenge3-user` | Ability to Assume Any Roles in AWS Account    | 

Run the `terraform apply -auto-approve` to create necessary resource before proceeding to Task 1.


### Tasks:

#### 1. Split Resource into Child Modules

Split (Move) the existing code into multiple child modules as described in below table. Each child module must be inside the `modules` folder.


| Resource Type  | Child Module Folder | 
| :---        |    :----:   | 
| `aws_launch_template`  | asg      | 
| `aws_autoscaling_group`  | asg   | 
| `kplabs-user` | iam    | 

Configure the appropriate module sources in the root module (main.tf) to load all child modules.

#### 2. Create Shared Config and Credentials File

Set up a shared AWS credentials and configuration files for this project.

* The `conf` and `credentials` file must be present in the `.aws` folder in `challenge-3` directory. 

* The config file must only have two profiles [asg] and [iam]

* Both the `[asg]` and `[iam]` profile in `./aws/conf` file should point to appropriate IAM roles that were created in `base-folder` using `role_arn`

* `[asg]` profile should point to ARN of IAM role with `EC2FullAccess` 
* `[iam]` profile should point to ARN of IAM role with `IAMFullAccess`

* The credential file must be defined with following format

```sh
[kplabs-challenge3-user]
aws_access_key_id = <ACCESS_KEY_FROM_OUTPUT>
aws_secret_access_key = <SECRET_KEY_FROM_OUTPUT>
```

Replace the access key and secret access key by fetching the value from `base-folder` state file

#### 3. Add Appropriate Provider Configuration

* ASG Child-Module should make use of `[asg]` profile.
* IAM Child-Module should make use of `[iam]` profile.
* Ensure there are no other profile in `conf` file.

#### 4. Deploy Resources

Run the `terraform apply -auto-approve` to create the resources.

Ensure ALL resources are deployed successfully.

#### 5. Prevent Change of Tags

Any change made to `tags` for auto-scaling group should be prevented to be deployed in actual infrastructure.

After you have applied solution, try changing tags for ASG and verify if Terraform plans to change/update it in actual resource.

### Destroy Infrastructure

Run `terraform destroy -auto-approve` to delete all infrastructure.

Run `terraform destroy -auto-approve` in `base-folder` to delete all infrastructure.



