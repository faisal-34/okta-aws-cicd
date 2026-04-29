locals {
  has_okta_metadata = var.okta_saml_metadata_xml != ""
}

# ── IAM Role: EC2 instance role for ECR access ──────────────────────────────
resource "aws_iam_role" "ec2_instance" {
  name = "okta-cicd-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_readonly" {
  role       = aws_iam_role.ec2_instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_ecr" {
  name = "okta-cicd-ec2-profile"
  role = aws_iam_role.ec2_instance.name
}

# ── IAM SAML Identity Provider (Okta as IdP) ───────────────────────────────
resource "aws_iam_saml_provider" "okta" {
  count                  = local.has_okta_metadata ? 1 : 0
  name                   = "OktaSSOProvider"
  saml_metadata_document = var.okta_saml_metadata_xml
}

# ── IAM Role: Admin access via Okta SSO ─────────────────────────────────────
resource "aws_iam_role" "okta_sso_admin" {
  count = local.has_okta_metadata ? 1 : 0
  name  = "OktaSSOAdminRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_saml_provider.okta[0].arn
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "okta_sso_admin" {
  count      = local.has_okta_metadata ? 1 : 0
  role       = aws_iam_role.okta_sso_admin[0].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ── IAM Role: Read-only access via Okta SSO ─────────────────────────────────
resource "aws_iam_role" "okta_sso_readonly" {
  count = local.has_okta_metadata ? 1 : 0
  name  = "OktaSSOReadOnlyRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_saml_provider.okta[0].arn
        }
        Action = "sts:AssumeRoleWithSAML"
        Condition = {
          StringEquals = {
            "SAML:aud" = "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "okta_sso_readonly" {
  count      = local.has_okta_metadata ? 1 : 0
  role       = aws_iam_role.okta_sso_readonly[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
