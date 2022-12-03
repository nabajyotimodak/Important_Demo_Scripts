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
  region  = var.aws_region
  profile = "default"
}


/*
aws_region               = "us-west-1a"
aws_instance_count       = "3"
aws_instance_type        = "c4.xlarge"
*/
