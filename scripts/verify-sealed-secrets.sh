#!/bin/bash

# ------------------------------
# Sealed Secrets Verification Tool
# ------------------------------

set -euo pipefail

SECRETS_DIR="manifests/sealed-secrets"
NAMESPACE="sealed-secrets" 

echo "Verifying sealed secrets in: $SECRETS_DIR"
echo "Target namespace: $NAMESPACE"
echo

for file in "$SECRETS_DIR"/*.yaml; do
  [[ -f "$file" ]] || continue  # skip if no files

  SECRET_NAME=$(grep 'name:' "$file" | head -n 1 | awk '{print $2}')
  if [[ -z "$SECRET_NAME" ]]; then
    echo "Could not extract secret name from $file"
    continue
  fi

  # Check if the actual Secret exists in the cluster
  if kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" &>/dev/null; then
    # Optionally: check if the data field exists
    if [[ $(kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" -o jsonpath="{.data}" | wc -c) -gt 5 ]]; then
      echo "$SECRET_NAME: Secret exists and contains data"
    else
      echo " $SECRET_NAME: Secret exists but has no data"
    fi
  else
    echo "$SECRET_NAME: Secret not found in namespace $NAMESPACE"
  fi
done

echo
echo "Verification complete. Review any or items above."
