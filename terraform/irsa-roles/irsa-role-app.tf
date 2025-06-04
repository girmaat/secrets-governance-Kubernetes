# -------------------------------
# IRSA Role for App Secrets Access
# -------------------------------

resource "aws_iam_role" "irsa_app" {
  name = "irsa-role-secrets-demo"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn  
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:default:irsa-secrets-demo"
        }
      }
    }]
  })

  tags = {
    Name        = "IRSA: SecretsManager + KMS access"
    Team        = "app"
    Environment = "dev"
    Purpose     = "Read DB credentials from AWS Secrets Manager"
  }
}

data "aws_iam_policy_document" "irsa_policy" {
  statement {
    sid    = "AllowReadSecret"
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      var.secret_arn  
    ]
    condition {
      test     = "StringEquals"
      variable = "secretsmanager:ResourceTag/env"
      values   = ["dev"]
    }
  }

  statement {
    sid    = "AllowDecryptWithKMS"
    effect = "Allow"
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      var.kms_key_arn
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [var.region]
    }
  }
}

resource "aws_iam_policy" "irsa_policy" {
  name        = "secretsmanager-irsa-app-policy"
  description = "Allow IRSA app to read SecretsManager secret + decrypt with KMS"
  policy      = data.aws_iam_policy_document.irsa_policy.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.irsa_app.name
  policy_arn = aws_iam_policy.irsa_policy.arn
}
