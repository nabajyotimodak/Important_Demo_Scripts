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
    bucket = "terraform-buck"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1" 
    # For State Locking, LockID
    dynamodb_table = "terraform-dev-state-table"    
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}