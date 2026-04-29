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
  description = "EC2 key pair name"
  type        = string
}

variable "okta_saml_metadata_xml" {
  description = "SAML metadata XML from Okta app"
  type        = string
  default     = ""
}

variable "app_image" {
  description = "Docker image URI (ECR)"
  type        = string
  default     = ""
}
