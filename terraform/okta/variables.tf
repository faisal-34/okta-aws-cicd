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
