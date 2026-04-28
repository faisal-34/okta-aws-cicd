# ── IAM SAML Identity Provider (Okta as IdP) ───────────────────────────────
resource "aws_iam_saml_provider" "okta" {
  name                   = "OktaSSOProvider"
  saml_metadata_document = var.okta_saml_metadata_xml
}

# ── IAM Role: Admin access via Okta SSO ─────────────────────────────────────
resource "aws_iam_role" "okta_sso_admin" {
  name = "OktaSSOAdminRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_saml_provider.okta.arn
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
  role       = aws_iam_role.okta_sso_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# ── IAM Role: Read-only access via Okta SSO ─────────────────────────────────
resource "aws_iam_role" "okta_sso_readonly" {
  name = "OktaSSOReadOnlyRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_saml_provider.okta.arn
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
  role       = aws_iam_role.okta_sso_readonly.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
