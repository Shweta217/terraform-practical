resource "aws_subnet" "terraform_pub_subnet" {
  count = "${length(var.public_subnet_cidr_block)}"
  vpc_id     = "${aws_vpc.terraform_vpc.id}"
  cidr_block = "${element(var.public_subnet_cidr_block,count.index)}"
  availability_zone = "${element(var.availability_zones,count.index)}"
  tags = {
    Name = "${element(var.public_subnet_names,count.index)}"
  }
}

resource "aws_subnet" "terraform_priv_subnet" {
  count = "${length(var.private_subnet_cidr_block)}"
  vpc_id     = "${aws_vpc.terraform_vpc.id}"
  cidr_block = "${element(var.private_subnet_cidr_block,count.index)}"
  availability_zone = "${element(var.availability_zones,count.index)}"
  tags = {
    Name = "${element(var.private_subnet_names,count.index)}"
  }
}
