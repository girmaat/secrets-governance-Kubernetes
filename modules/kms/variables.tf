variable "description" {
  description = "KMS key description"
  type        = string
}

variable "enable_key_rotation" {
  description = "Enable automatic key rotation"
  type        = bool
  default     = true
}

variable "alias_name" {
  description = "Name of the alias to create (without 'alias/' prefix)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the KMS key"
  type        = map(string)
  default     = {}
}
