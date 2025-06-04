variable "secret_arn" {
  description = "ARN of the Secrets Manager secret to rotate"
  type        = string
}

variable "kms_key_arn" {
  description = "KMS key ARN used to encrypt the secret"
  type        = string
}
