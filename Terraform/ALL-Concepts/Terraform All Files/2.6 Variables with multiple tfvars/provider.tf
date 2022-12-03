# terraform plan --var-file="web.tfvars"
# terraform plan --var-file="app.tfvars"

# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region  = "var.aws_region"
  profile = "default"
}