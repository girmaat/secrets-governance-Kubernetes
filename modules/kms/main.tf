resource "aws_kms_key" "this" {
  description             = var.description
  deletion_window_in_days = 30
  enable_key_rotation     = var.enable_key_rotation

  tags = var.tags
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.this.id
}
