# ── AWS Infrastructure (EC2, ECR, IAM) ───────────────────────────────────────
# NOTE: Okta SSO setup is a one-time manual step — see terraform/okta/ directory.
# Run it separately after obtaining the SAML metadata XML from AWS IAM.

module "aws_infra" {
  source = "./aws"

  aws_region             = var.aws_region
  instance_type          = var.instance_type
  key_name               = var.key_name
  app_image              = var.app_image
  okta_saml_metadata_xml = var.okta_saml_metadata_xml
}

# ── Outputs ───────────────────────────────────────────────────────────────────
output "ec2_public_ip" {
  value = module.aws_infra.ec2_public_ip
}

output "ec2_public_dns" {
  value = module.aws_infra.ec2_public_dns
}

output "okta_sso_admin_role_arn" {
  value = module.aws_infra.okta_sso_admin_role_arn
}
