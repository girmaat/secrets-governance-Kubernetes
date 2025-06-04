#!/bin/bash

# --------------------------------------------
# Enhanced Sealed Secret Generator with Checks
# --------------------------------------------

set -euo pipefail

# Validate inputs
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <secret-name> <key>"
  echo "Example: $0 db-password password"
  exit 1
fi

SECRET_NAME=$1
KEY=$2
OUTPUT_PATH="manifests/sealed-secrets/${SECRET_NAME}-sealed.yaml"
CERT_PATH="pub-cert.pem"

# Check that the controller is installed and running
if ! kubectl get secret -n sealed-secrets -l sealedsecrets.bitnami.com/sealed-secrets-key >/dev/null 2>&1; then
  echo "Sealed Secrets key not found. Ensure the controller is installed and key is available."
  exit 1
fi

# Ensure the public cert exists
if [[ ! -f "$CERT_PATH" ]]; then
  echo "Error: $CERT_PATH not found. Export it from the controller before sealing."
  echo "Use:"
  echo "  kubectl get secret -n sealed-secrets -l sealedsecrets.bitnami.com/sealed-secrets-key \\"
  echo "    -o jsonpath='{.items[0].data[\"tls.crt\"]}' | base64 -d > pub-cert.pem"
  exit 1
fi

# Prompt user to enter the secret value
read -sp "Enter secret value for key '$KEY': " VALUE
echo

# Confirm where the output will go
echo "Sealing and saving to: $OUTPUT_PATH"

# Ensure the output directory exists
mkdir -p "$(dirname "$OUTPUT_PATH")"

# Create and seal the secret
echo -n "$VALUE" | kubectl create secret generic "$SECRET_NAME" \
  --dry-run=client --from-literal="$KEY"=/dev/stdin -o json | \
  kubeseal --format yaml --cert "$CERT_PATH" > "$OUTPUT_PATH"

# Final output
echo "Sealed secret saved to: $OUTPUT_PATH"

# Post-sealing guidance
echo
echo "Next steps:"
echo "  1. Review the sealed secret file:"
echo "     cat $OUTPUT_PATH"
echo "  2. Commit it to Git:"
echo "     git add $OUTPUT_PATH"
echo "     git commit -m 'Add sealed secret: $SECRET_NAME'"
echo "     git push origin <your-branch>"
echo "  3. Apply it to the cluster (if safe to do so):"
echo "     kubectl apply -f $OUTPUT_PATH"
echo
echo "🛠 Troubleshooting tips:"
echo "  - Check controller logs:"
echo "      kubectl logs -n sealed-secrets -l app.kubernetes.io/name=sealed-secrets"
echo "  - Check for Secret creation or failure events:"
echo "      kubectl get events -n sealed-secrets"
