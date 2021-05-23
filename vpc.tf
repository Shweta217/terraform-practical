resource "aws_vpc" "terraform_vpc" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "default"

  tags = {
    Name = "terraform_vpc"
  }
}


resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
  description = "Allow SSH and http inbound traffic"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

 ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
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
    Name = "terraform_sg"
  }
depends_on = [
   aws_vpc.terraform_vpc
  ]
}

