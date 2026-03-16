variable "s3_base_object" {
    type = string
    default = "base.txt"
}

variable "s3_buckets" {
    type = set(string)
    default = ["kplabs-1","kplabs-2"]
}

variable "name_prefix" {
    type = string
    description = "Prefix for s3 bucket name that will come from randon_pet"
}