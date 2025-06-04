# KMS Module

This reusable Terraform module provisions a KMS key with:

- Rotation enabled
- Alias support (e.g., alias/dev-secrets)
- Tags for team/owner/env

## Usage

```hcl
module "kms" {
  source              = "./modules/kms"
  description         = "KMS key for Secrets Manager encryption"
  alias_name          = "dev-secrets"
  enable_key_rotation = true
  tags = {
    env  = "dev"
    team = "platform"
  }
}
