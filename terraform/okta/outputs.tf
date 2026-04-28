output "okta_app_id" {
  description = "Okta AWS SAML App ID"
  value       = okta_app_saml.aws.id
}

output "okta_saml_metadata_url" {
  description = "Okta SAML metadata URL (use to configure AWS IAM Identity Provider)"
  value       = "https://${var.okta_org_name}.okta.com/app/${okta_app_saml.aws.id}/sso/saml/metadata"
}

output "okta_aws_admins_group_id" {
  description = "Okta AWS Admins group ID"
  value       = okta_group.aws_admins.id
}

output "okta_aws_readonly_group_id" {
  description = "Okta AWS ReadOnly group ID"
  value       = okta_group.aws_readonly.id
}
