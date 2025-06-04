module "secrets_manager" {
  source       = "./secrets-manager"
  kms_key_arn  = var.kms_key_arn
  env          = var.env
  team         = var.team
}

module "irsa_roles" {
  source            = "./irsa-roles"
  oidc_provider_arn = var.oidc_provider_arn
  oidc_provider_url = var.oidc_provider_url
  secret_arn        = module.secrets_manager.db_secret_arn 
  kms_key_arn       = var.kms_key_arn
  region            = var.region
}

module "kms" {
  source      = "./modules/kms"
  description = "KMS key for Secrets Manager secret rotation"
  alias_name  = "dev-secrets"
  tags = {
    team = "platform"
    env  = "dev"
  }
}

module "secrets_manager_rotation" {
  source      = "./secret-rotation/secrets-manager/terraform"
  secret_arn  = module.secrets_manager.db_secret_arn
  kms_key_arn = module.kms.key_arn
}


