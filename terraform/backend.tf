terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket = "okta-cicd-tfstate-493675641194"
    key    = "okta-aws-cicd/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # okta provider is used only for manual SSO setup via terraform/okta/
    # Run that directory separately — not part of the automated pipeline.
  }
}

provider "aws" {
  region = var.aws_region
}

provider "okta" {
  org_name  = var.okta_org_name
  base_url  = "okta.com"
  api_token = var.okta_api_token
}
