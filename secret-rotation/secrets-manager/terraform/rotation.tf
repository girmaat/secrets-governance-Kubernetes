resource "aws_secretsmanager_secret_rotation" "enable_rotation" {
  secret_id           = var.secret_arn
  rotation_lambda_arn = aws_lambda_function.rotation_lambda.arn

  rotation_rules {
    automatically_after_days = 30
  }
}
