# --- VARIABLES ---
# These variables are intentionally loose. Your job is to add validation
# blocks, tighten the types, and add custom conditions.

# TODO: Add a validation block that only permits us-east-1, us-west-2, eu-west-1
variable "allowed_regions" {
  description = "List of AWS regions where deployment is permitted"
  type        = list(string)
  default     = ["us-east-1"]

  validation {
    condition = alltrue([
      for region in var.allowed_regions : contains(["us-east-1", "us-west-2", "eu-west-1"], region)
    ])
    error_message = "Resources are only allowed to be deployed in us-east-1, us-west-2, and eu-west-1"
  }
}

# TODO: Change type from "any" to a proper object type requiring
# subnet_id (string) and availability_zone (string).
# TODO: Add a validation that subnet_id starts with "subnet-"
variable "subnet_config" {
  description = "Subnet configuration for the EC2 instance"
  type = object({
    subnet_id         = string
    availability_zone = string
  })

  default = {
    subnet_id         = "subnet-placeholder"
    availability_zone = "us-east-1a"
  }

  validation {
    condition     = startswith(var.subnet_config.subnet_id, "subnet-")
    error_message = "subnet_id must start with 'subnet-'."
  }
}

# TODO: Add a validation block that only allows instance types starting with t2. or t3.
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = can(regex("^(t2|t3)\\.", var.instance_type))
    error_message = "Only t2 or t3 instances may be deployed"
  }
}

variable "required_architecture" {
  description = "CPU architecture for AMI lookup"
  type        = string
  default     = "x86_64"
}
