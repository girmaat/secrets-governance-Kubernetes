# 📦 Secrets Manager Rotation Module

This Terraform module provisions:
- A Lambda function to rotate a Secrets Manager secret
- An IAM role with least-privilege permissions
- KMS support for encryption
- Automatic rotation setup (30-day cycle)

---

## ✅ Secret Input: Simplest Secure Pattern

To provide the secret content (e.g., app password), we use:

### `terraform.tfvars` (DO NOT COMMIT)

```hcl
db_password = "MySecurePassword123!"
