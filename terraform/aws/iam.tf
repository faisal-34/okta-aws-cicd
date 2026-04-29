locals {
  has_okta_metadata = var.okta_saml_metadata_xml != ""
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
