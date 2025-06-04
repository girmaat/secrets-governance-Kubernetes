#!/bin/bash

# --------------------------------------------
# GitOps Drift Detection for Sealed Secrets
# --------------------------------------------

set -euo pipefail

SECRETS_DIR="manifests/sealed-secrets"
NAMESPACE="sealed-secrets"  # Adjusted as per your setup

echo "Checking for drift between Git and cluster (namespace: $NAMESPACE)"
echo

# Collect expected secret names from SealedSecret YAMLs
EXPECTED_SECRETS=()
for file in "$SECRETS_DIR"/*.yaml; do
  [[ -f "$file" ]] || continue
  SECRET_NAME=$(grep 'name:' "$file" | head -n 1 | awk '{print $2}')
  [[ -n "$SECRET_NAME" ]] && EXPECTED_SECRETS+=("$SECRET_NAME")
done

# Get actual Kubernetes secrets in the namespace
ACTUAL_SECRETS=$(kubectl get secrets -n "$NAMESPACE" -o jsonpath="{.items[*].metadata.name}")

# Convert to arrays
ACTUAL_ARRAY=($ACTUAL_SECRETS)

echo "SealedSecrets in Git but NOT in cluster:"
for expected in "${EXPECTED_SECRETS[@]}"; do
  if [[ ! " ${ACTUAL_ARRAY[*]} " =~ " ${expected} " ]]; then
    echo "$expected is missing from the cluster"
  fi
done

echo
echo "Secrets in cluster NOT tracked in Git:"
for actual in "${ACTUAL_ARRAY[@]}"; do
  if [[ ! -f "$SECRETS_DIR/${actual}-sealed.yaml" ]]; then
    echo "$actual exists in cluster but not in Git"
  fi
done

echo
echo "Drift check complete. Investigate or lines as needed."
