terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "nabavpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "nabavpc"
  }
}

resource "aws_subnet" "publicsub" {
  vpc_id     = aws_vpc.nabavpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "publicsub"
  }
}

resource "aws_subnet" "privatesub" {
  vpc_id     = aws_vpc.nabavpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "privatesub"
  }
}

resource "aws_internet_gateway" "nabaigw" {
  vpc_id = aws_vpc.nabavpc.id

  tags = {
    Name = "nabaigw"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.nabavpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nabaigw.id
  }

  tags = {
    Name = "publicrt"
  }
}

resource "aws_route_table_association" "pubrtasso" {
  subnet_id      = aws_subnet.publicsub.id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_eip" "nabaeip" {
  vpc      = true
}

resource "aws_nat_gateway" "nabanatgw" {
  allocation_id = aws_eip.nabaeip.id
  subnet_id     = aws_subnet.publicsub.id

  tags = {
    Name = "nabanatgw"
  }
}


resource "aws_route_table" "privatert" {
  vpc_id = aws_vpc.nabavpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nabanatgw.id
  }

  tags = {
    Name = "privatert"
  }
}

resource "aws_route_table_association" "prirtasso" {
  subnet_id      = aws_subnet.privatesub.id
  route_table_id = aws_route_table.privatert.id
}

resource "aws_security_group" "publicsg" {
  name        = "publicsg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.nabavpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "publicsg"
  }
}

resource "aws_security_group" "privatesg" {
  name        = "privatesg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.nabavpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    security_groups  = [aws_security_group.publicsg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "privatesg"
  }
}

resource "aws_instance" "publicec2" {
  ami                           = "ami-05fa00d4c63e32376"
  instance_type                 = "t2.micro"
  associate_public_ip_address   = true
  key_name                      = "15032022"
  subnet_id                     = aws_subnet.publicsub.id
  vpc_security_group_ids        = [aws_security_group.publicsg.id]
  depends_on                    = [aws_subnet.publicsub]

  tags = {
    Name = "publicec2"
  }
}

resource "aws_instance" "private_ec2" {
  ami                           = "ami-05fa00d4c63e32376"
  instance_type                 = "t2.micro"
  subnet_id                     = aws_subnet.privatesub.id
  vpc_security_group_ids        = [aws_security_group.privatesg.id]
  key_name                      = "15032022"
  depends_on                    = [aws_subnet.privatesub]

  tags = {
    Name = "private_ec2"
  }
}
