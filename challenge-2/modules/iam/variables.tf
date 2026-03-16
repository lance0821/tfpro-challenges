variable "org-name" { 
    type = string
    default = "kplabs"
}

variable "name_prefix" {
    type = string
    description = "Prefix for s3 bucket name that will come from randon_pet"
}