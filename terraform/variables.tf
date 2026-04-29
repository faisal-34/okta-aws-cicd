variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "okta_org_name" {
  description = "Okta organization name (subdomain, e.g. trial-2304070)"
  type        = string
}

variable "okta_api_token" {
  description = "Okta API token"
  type        = string
  sensitive   = true
}

variable "app_image" {
  description = "Docker image URI from ECR (set by pipeline after build)"
  type        = string
  default     = ""
}

variable "okta_saml_metadata_xml" {
  description = "SAML metadata XML from Okta (download from Okta app metadata URL). Leave empty to skip SAML provider creation."
  type        = string
  default     = ""
}
