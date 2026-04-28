# ── Okta Groups ──────────────────────────────────────────────────────────────
resource "okta_group" "aws_admins" {
  name        = "AWS-Admins"
  description = "Users with AWS Admin access via SSO"
}

resource "okta_group" "aws_readonly" {
  name        = "AWS-ReadOnly"
  description = "Users with AWS Read-Only access via SSO"
}

# ── Okta AWS SAML App ─────────────────────────────────────────────────────────
resource "okta_app_saml" "aws" {
  label             = "Amazon Web Services"
  preconfigured_app = "amazon_aws"
  status            = "ACTIVE"

  app_settings_json = jsonencode({
    awsEnvironmentType  = "aws.amazon"
    loginURL            = "https://signin.aws.amazon.com/saml"
    identityProviderArn = ""
    sessionDuration     = 3600
    roleValuePattern    = "arn:aws:iam::${var.aws_account_id}:saml-provider/OktaSSOProvider,arn:aws:iam::${var.aws_account_id}:role/$${roleValue}"
  })
}

# ── Assign Groups to App ──────────────────────────────────────────────────────
resource "okta_app_group_assignment" "aws_admins" {
  app_id   = okta_app_saml.aws.id
  group_id = okta_group.aws_admins.id

  profile = jsonencode({
    role      = var.aws_admin_role_arn
    samlRoles = [var.aws_admin_role_arn]
  })
}

resource "okta_app_group_assignment" "aws_readonly" {
  app_id   = okta_app_saml.aws.id
  group_id = okta_group.aws_readonly.id

  profile = jsonencode({
    role      = var.aws_readonly_role_arn
    samlRoles = [var.aws_readonly_role_arn]
  })
}
