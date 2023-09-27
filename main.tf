provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "My-VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "MY=VPC-PUBSUB"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "MY=VPC-PVTSUB" 
  }
}

resource "aws_security_group" "s_group" {
  name = "s_group"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "MY=VPC-SG" 
  }
}

resource "aws_instance" "instance1" {
  ami = "ami-08abb3eeacc61972d"
  instance_type = "t2.micro"     
  subnet_id = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.s_group.id]
  key_name = "key1"
  tags = {
    purpose = "Assignment"
  }
}

resource "aws_ebs_volume" "my_volume" {
  availability_zone = aws_subnet.public.availability_zone
  size = 8
  type = "gp2"
  encrypted = false
}
