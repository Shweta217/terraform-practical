resource "aws_internet_gateway" "terraform_gw" {
  vpc_id = "${aws_vpc.terraform_vpc.id}"

  tags = {
    Name = "terraform_gw"
  }
}

