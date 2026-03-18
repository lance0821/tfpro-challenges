
variable "environement" {
  type = string
}

variable "s3_buckets" {
    type = set(string)
}

variable "sg_name" {}
variable "s3_base_object" {}

variable "org-name" {}

variable "region" {}