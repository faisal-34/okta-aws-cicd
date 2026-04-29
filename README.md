# Okta AWS CI/CD

A CI/CD pipeline that builds and deploys a Node.js app to AWS EC2, with Okta SSO federated access to the AWS Console via SAML 2.0.

## Project Structure

```
.
├── .github/workflows/
│   └── pipeline.yml        # CI/CD: Build → Terraform Apply → Deploy
├── app/
│   ├── Dockerfile           # Node.js container image
│   └── app.js               # Express app (port 3000)
├── terraform/
│   ├── backend.tf           # S3 remote state (us-east-1)
│   ├── main.tf              # Root module — calls aws_infra
│   ├── variables.tf         # Root variables (region, image, SAML metadata)
│   ├── aws/
│   │   ├── ec2.tf           # EC2 instance + security group
│   │   ├── iam.tf           # EC2 role, SAML provider, OktaSSO roles (conditional)
│   │   └── variables.tf     # VPC/subnet IDs, instance type, etc.
│   └── okta/                # Run manually (not in CI)
│       ├── provider.tf      # Okta provider config
│       ├── app.tf           # Okta SAML app + groups + group assignments
│       ├── variables.tf     # okta_org_name, okta_api_token, aws_account_id
│       ├── outputs.tf       # App ID, metadata URL, group IDs
│       └── terraform.tfvars # (gitignored) API token and org name
└── architecture.html        # Visual architecture diagram
```

## How It Works

### CI/CD Pipeline (`.github/workflows/pipeline.yml`)
1. **Build** — Docker image built and pushed to ECR (`okta-aws-cicd`)
2. **Terraform** — `terraform apply` creates/updates EC2, IAM roles, SAML provider
3. **Deploy** — SSH into EC2, pull latest image from ECR, restart container

### Okta SSO (run once manually from `terraform/okta/`)
1. Creates Okta groups: `aws_<accountid>_OktaSSOAdminRole`, `aws_<accountid>_OktaSSOReadOnlyRole`
2. Creates preconfigured AWS SAML app in Okta with group-based role mapping
3. AWS Terraform creates `OktaSSOProvider` (IAM SAML provider) + `OktaSSOAdminRole` / `OktaSSOReadOnlyRole`
4. Users in the Okta groups can sign into the AWS Console via the Okta dashboard tile

## Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM secret key |
| `EC2_SSH_KEY` | Private key for EC2 SSH (Okta.pem contents) |

## AWS Resources

| Resource | Value |
|----------|-------|
| Region | `us-east-1` |
| ECR Repo | `okta-aws-cicd` |
| S3 State Bucket | `okta-cicd-tfstate-493675641194` |
| EC2 IAM Profile | `okta-cicd-ec2-profile` |
| SAML Provider | `OktaSSOProvider` |
| SSO Roles | `OktaSSOAdminRole`, `OktaSSOReadOnlyRole` |

## Okta Configuration

| Setting | Value |
|---------|-------|
| Org | `trial-2304070.okta.com` |
| SAML App | `amazon_aws` (preconfigured) |
| Group mapping | Enabled — role extracted from group name |
| Role pattern | `arn:aws:iam::${accountid}:saml-provider/OktaSSOProvider,arn:aws:iam::${accountid}:role/${role}` |
