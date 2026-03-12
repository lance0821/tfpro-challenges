# --- VARIABLES ---

# BUG: This variable holds a secret but is not marked as sensitive.
# TODO (Task 3): Add sensitive = true to this variable.
variable "db_password" {
  description = "Database password for the application"
  type        = string
  default     = "SuperSecret123!"
}
