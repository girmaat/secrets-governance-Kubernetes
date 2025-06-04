#!/bin/bash

set -euo pipefail

BLUE='\033[1;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

DEV1_HOME="/home/dev1"
PROJECT_DIR="${DEV1_HOME}/secure-secrets-platform-k8s-aws"
TARGET="${PROJECT_DIR}/pub-cert.pem"
TMP_CERT="/tmp/pub-cert.pem"

# Full path to kubectl binary
KUBECTL_BIN="/usr/local/bin/kubectl"  # or use `which kubectl`

# Use working KUBECONFIG (from 'user')
echo -e "${BLUE}📤 Step 1: Exporting public cert using known kubeconfig...${NC}"
"$KUBECTL_BIN" --kubeconfig=/home/user/.kube/config get secret -n sealed-secrets \
  -l sealedsecrets.bitnami.com/sealed-secrets-key \
  -o jsonpath='{.items[0].data.tls\.crt}' | base64 -d > "$TMP_CERT"

echo -e "${BLUE}🔐 Step 2: Moving cert to dev1's project directory...${NC}"
mv "$TMP_CERT" "$TARGET"
chown dev1:dev1 "$TARGET"
chmod 644 "$TARGET"

echo -e "${GREEN}[✔] pub-cert.pem is now available at: $TARGET${NC}"
