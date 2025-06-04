variable "kms_key_arn" {
  description = "ARN of the KMS key to encrypt the secret"
  type        = string
}

variable "env" {
  description = "Environment identifier (e.g., dev, staging, prod)"
  type        = string
}

variable "team" {
  description = "Owning team for this secret"
  type        = string
}

variable "db_password" {
  description = "App database password (do not commit)"
  type        = string
  sensitive   = true
}

variable "db_username" {
  description = "Database username for the app"
  type        = string
  default     = "appuser"
}