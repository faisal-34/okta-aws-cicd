# ── Step 1: Create Okta AWS SAML App ─────────────────────────────────────────
# (Run terraform/okta/ first to get metadata URL, then feed into terraform/aws/)

# ── Step 2: Create AWS IAM SAML Provider + EC2 ───────────────────────────────
module "okta" {
  source = "./okta"

  okta_org_name         = var.okta_org_name
  okta_api_token        = var.okta_api_token
  aws_account_id        = var.aws_account_id
  aws_admin_role_arn    = module.aws_infra.okta_sso_admin_role_arn
  aws_readonly_role_arn = module.aws_infra.okta_sso_readonly_role_arn
}

module "aws_infra" {
  source = "./aws"

  aws_region             = var.aws_region
  instance_type          = var.instance_type
  key_name               = var.key_name
  app_image              = var.app_image
  okta_saml_metadata_xml = file("${path.module}/okta-metadata.xml")
}

# ── Outputs ───────────────────────────────────────────────────────────────────
output "ec2_public_ip" {
  value = module.aws_infra.ec2_public_ip
}

output "ec2_public_dns" {
  value = module.aws_infra.ec2_public_dns
}

output "okta_saml_metadata_url" {
  value       = module.okta.okta_saml_metadata_url
  description = "Download this XML and save as terraform/okta-metadata.xml"
}

output "okta_sso_admin_role_arn" {
  value = module.aws_infra.okta_sso_admin_role_arn
}
