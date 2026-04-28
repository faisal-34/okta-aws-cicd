variable "okta_org_name" {
  description = "Okta organization name (subdomain)"
  type        = string
}

variable "okta_api_token" {
  description = "Okta API token"
  type        = string
  sensitive   = true
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "aws_admin_role_arn" {
  description = "ARN of the AWS Admin IAM role for SSO"
  type        = string
}

variable "aws_readonly_role_arn" {
  description = "ARN of the AWS ReadOnly IAM role for SSO"
  type        = string
}
