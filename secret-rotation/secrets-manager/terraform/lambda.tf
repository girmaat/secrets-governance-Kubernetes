data "archive_file" "rotation_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/rotate-db-secret.py"
  output_path = "${path.module}/lambda/rotate-db-secret.zip"
}

resource "aws_lambda_function" "rotation_lambda" {
  function_name = "rotate-db-secret"
  role          = aws_iam_role.rotation_lambda_role.arn
  handler       = "rotate-db-secret.handler"
  runtime       = "python3.11"
  timeout       = 30

  filename         = data.archive_file.rotation_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.rotation_zip.output_path)
}
