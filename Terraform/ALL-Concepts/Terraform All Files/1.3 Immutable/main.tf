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
  region  = "us-east-1"
  profile = "default"
}

# Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami               = "ami-05fa00d4c63e32376"
  instance_type     = "t2.micro"
  #availability_zone = "ap-south-1b"
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "web"
    #"tag1" = "Update-test-1"    
  }
}


