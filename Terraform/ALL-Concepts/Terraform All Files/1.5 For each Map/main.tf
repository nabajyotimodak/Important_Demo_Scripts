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

# Create 4 S3 Buckets
resource "aws_s3_bucket" "mys3bucket" {

  # for_each Meta-Argument
  for_each = {
    dev  = "my-dapp-bucket-455"           # key -> dev ; value -> "my-dapp-bucket-455"
    qa   = "my-qapp-bucket-455"
    stag = "my-sapp-bucket-455"
    prod = "my-papp-bucket-455"
  }

  bucket = "${each.key}-${each.value}"    # "dev-my-dapp-bucket-455"
  acl    = "private"

  tags = {
    Environment = each.key 
    bucketname  = "${each.key}-${each.value}"
    eachvalue   = each.value
  }
}


---


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

# AWS_Instance_in_different_availability_Zones
resource "aws_instance" "my-ec2" {
  for_each = {
    dev-ec2 = "us-east-1a"
    test-ec2 = "us-east-1b"
  }
  ami 		          = "ami-079b54jk2658df547"
  availability_zone	= "${each.value}"
  instance_type	    = "t3.medium"
  tags = {
    Name = "${each.key}"
    Environment = "${each.key}"
  }
}

