# Okta AWS CI/CD

Infrastructure and application pipeline integrating Okta identity with AWS services using Terraform and GitHub Actions.

## Structure

```
.
├── terraform/
│   ├── aws/          # AWS resource definitions
│   ├── okta/         # Okta resource definitions
│   └── backend.tf    # S3 remote state backend
├── app/
│   ├── Dockerfile    # Container image
│   └── app.js        # Node.js application
└── .github/workflows/
    └── pipeline.yml  # CI/CD pipeline
```

## Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `OKTA_ORG_NAME` | Okta organization name |
| `OKTA_API_TOKEN` | Okta API token |
