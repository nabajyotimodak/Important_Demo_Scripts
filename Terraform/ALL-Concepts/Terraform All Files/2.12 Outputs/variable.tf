# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "ap-south-1"
}

variable "ec2_ami_id" {
  description = "AMI ID"
  type = string  
  default = "ami-079b5e5b3971bd10d"
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type = string
  default = "t2.micro"
}
