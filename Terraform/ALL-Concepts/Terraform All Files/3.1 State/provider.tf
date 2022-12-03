# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  # Adding Backend as S3 for Remote State Storage
  backend "s3" {
    bucket = "my-terraform-states-2106"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"   
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}

