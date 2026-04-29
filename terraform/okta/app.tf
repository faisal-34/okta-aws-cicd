# ── Okta Groups ──────────────────────────────────────────────────────────────
resource "okta_group" "aws_admins" {
  name        = "aws_${var.aws_account_id}_OktaSSOAdminRole"
  description = "Users with AWS Admin access via SSO"
}

resource "okta_group" "aws_readonly" {
  name        = "aws_${var.aws_account_id}_OktaSSOReadOnlyRole"
  description = "Users with AWS Read-Only access via SSO"
}

# ── Okta AWS SAML App ─────────────────────────────────────────────────────────
resource "okta_app_saml" "aws" {
  label             = "Amazon Web Services"
  preconfigured_app = "amazon_aws"
  status            = "ACTIVE"

  app_settings_json = jsonencode({
    awsEnvironmentType = "aws.amazon"
    sessionDuration    = 3600
    useGroupMapping    = true
    joinAllRoles       = false
    roleValuePattern   = "arn:aws:iam::$${accountid}:saml-provider/OktaSSOProvider,arn:aws:iam::$${accountid}:role/$${role}"
  })
}

# ── Assign Groups to App ──────────────────────────────────────────────────────
resource "okta_app_group_assignment" "aws_admins" {
  app_id   = okta_app_saml.aws.id
  group_id = okta_group.aws_admins.id
}

resource "okta_app_group_assignment" "aws_readonly" {
  app_id   = okta_app_saml.aws.id
  group_id = okta_group.aws_readonly.id
}
