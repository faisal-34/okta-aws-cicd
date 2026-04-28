terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "okta-aws-cicd/terraform.tfstate"
    region = "us-east-1"
  }
}
