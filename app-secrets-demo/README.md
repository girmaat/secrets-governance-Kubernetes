# app-secrets-demo

A minimal Flask app that demonstrates secrets delivery via:

- Bitnami Sealed Secrets (sealed + decrypted at deploy time)
- AWS Secrets Manager via IRSA (for dynamic access)
- CloudTrail & Grafana observability

## Endpoints

- `/` – Returns the secret from environment or Kubernetes secret
- `/health` – Simple liveness probe

## Setup

1. Seal a secret and apply:
    ```bash
    echo -n 'my-secret-token' | kubectl create secret generic app-secret --dry-run=client --from-literal=secret-value=... -o yaml | \
    kubeseal --cert pub-cert.pem --format yaml > sealed-secret-template.yaml
    ```

2. Apply manifests:
    ```bash
    kubectl apply -f sealed-secret-template.yaml
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    ```

3. Port forward:
    ```bash
    kubectl port-forward svc/app-secrets-demo 8080:80
    ```

4. Test:
    ```bash
    curl http://localhost:8080/
    ```

