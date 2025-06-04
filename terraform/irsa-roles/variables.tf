variable "oidc_provider_arn" {
  description = "The ARN of the EKS OIDC provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "The URL of the EKS OIDC provider"
  type        = string
}

variable "secret_arn" {
  description = "ARN of the secret in AWS Secrets Manager"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the customer-managed KMS key for secrets encryption"
  type        = string
}

variable "region" {
  description = "AWS region for conditional access policies"
  type        = string
}


