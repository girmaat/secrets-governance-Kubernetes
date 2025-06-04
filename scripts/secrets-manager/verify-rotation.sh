#!/bin/bash

# --------------------------------------
# Secret Rotation Verification Script
# --------------------------------------

SECRET_NAME="/dev/app/db-password"  # Update as needed
REGION="us-east-1"

echo "Describing secret: $SECRET_NAME"

aws secretsmanager describe-secret \
  --secret-id "$SECRET_NAME" \
  --region "$REGION" \
  --query '{Name:Name, RotationEnabled:RotationEnabled, LastChangedDate:LastChangedDate, LastRotatedDate:LastRotatedDate, RotationLambdaARN:RotationLambdaARN, Tags:Tags}' \
  --output table

echo -e "\nChecking secret versions:"
aws secretsmanager list-secret-version-ids \
  --secret-id "$SECRET_NAME" \
  --region "$REGION" \
  --query 'SecretVersions[*].{VersionId:VersionId, Stages:VersionStages}' \
  --output table

echo -e "\nChecking if rotation Lambda exists:"
LAMBDA_ARN=$(aws secretsmanager describe-secret --secret-id "$SECRET_NAME" --region "$REGION" --query 'RotationLambdaARN' --output text)
aws lambda get-function-configuration --function-name "$LAMBDA_ARN" --region "$REGION"

echo -e "\nDone: Secret + Lambda rotation config verified."
