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
  region  = "ap-south-1"
  profile = "default"
}

# Create EC2 Instance
resource "aws_instance" "web" {
  ami               = "ami-079b5e5b3971bd10d" # Amazon Linux
  instance_type     = "t2.micro"
  #availability_zone = "ap-south-1a"
  availability_zone = "ap-south-1b"
  tags = {
    "Name" = "web-1"
  }
  lifecycle {
    create_before_destroy = true
  }
}
