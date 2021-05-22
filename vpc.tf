variable "az" {
default = "ap-south-1a"
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_internet_gateway" "terraform_gw" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_gw"
  }
}


resource "aws_subnet" "terraform_subnet" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.az
  tags = {
    Name = "terraform_subnet"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
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
    Name = "allow_ssh"
  }
depends_on = [
   aws_vpc.terraform_vpc
  ]
}


resource "aws_route_table" "terraform_1st_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    #cidr_block = "0.0.0.0/0"
    cidr_block = "203.192.214.80/32"
    gateway_id = aws_internet_gateway.terraform_gw.id
  }

  tags = {
    Name = "terraform_1st_subnet_rt"
  }
}

resource "aws_route_table_association" "rt_1st_associate_with_terraform_subnet" {
  subnet_id      = aws_subnet.terraform_subnet.id
  route_table_id = aws_route_table.terraform_1st_rt.id
}
