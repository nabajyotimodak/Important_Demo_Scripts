variable "vpc_id" {
  description = "Will get VPC ID"
  type = string
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_subnet" "example" {
  vpc_id            = data.aws_vpc.selected.id
  availability_zone = "ap-south-1a"
  cidr_block        = "10.0.1.0/24"
}
