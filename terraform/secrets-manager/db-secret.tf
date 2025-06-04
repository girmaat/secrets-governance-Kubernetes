resource "aws_secretsmanager_secret" "db_password" {
  name        = "/dev/app/db-password"
  description = "Database password for dev application"

  kms_key_id  = var.kms_key_arn  

  tags = {
    env         = "dev"
    team        = "app"
    rotation    = "enabled"
    created_by  = "terraform"
  }
}

resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id = aws_secretsmanager_secret.db_password.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}
