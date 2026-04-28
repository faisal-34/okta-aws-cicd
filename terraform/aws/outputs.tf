output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.app.public_dns
}

output "okta_saml_provider_arn" {
  description = "ARN of the Okta SAML Identity Provider"
  value       = aws_iam_saml_provider.okta.arn
}

output "okta_sso_admin_role_arn" {
  description = "ARN of the Okta SSO Admin IAM Role"
  value       = aws_iam_role.okta_sso_admin.arn
}

output "okta_sso_readonly_role_arn" {
  description = "ARN of the Okta SSO ReadOnly IAM Role"
  value       = aws_iam_role.okta_sso_readonly.arn
}
