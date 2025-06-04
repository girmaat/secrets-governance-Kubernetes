# Gitleaks Guide: Secret Scanning in Our Kubernetes Secrets Platform

## Purpose

Gitleaks is used to prevent accidental exposure of secrets — such as API keys, passwords, tokens, and AWS credentials — in Git commits and pull requests.

We use it to scan:

- Terraform files
- Kubernetes manifests
- Python scripts
- Shell scripts
- YAML configs
- JSON files

This is critical for securing both:
- AWS Secrets Manager–based secrets
- Bitnami Sealed Secrets (coming soon)

---

## Local Use (Dev1, Dev2, DevOpsAdmin)

### 1. Install Gitleaks

#### With `sudo`:
```bash
curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.18.1/gitleaks_8.18.1_linux_x64.tar.gz -o gitleaks.tar.gz
tar -xvzf gitleaks.tar.gz
sudo mv gitleaks /usr/local/bin/
chmod +x /usr/local/bin/gitleaks


#### With `sudo`:
mkdir -p $HOME/bin
curl -sSL https://github.com/gitleaks/gitleaks/releases/download/v8.18.1/gitleaks_8.18.1_linux_x64.tar.gz -o gitleaks.tar.gz
tar -xvzf gitleaks.tar.gz
mv gitleaks $HOME/bin/
chmod +x $HOME/bin/gitleaks
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc

### 2. Run a Scan
- Basic scan:
gitleaks detect --source . --config-path .gitleaks.toml

- Scan full Git history (optional):
gitleaks detect --source . --log-opts "--all" --config-path .gitleaks.toml
