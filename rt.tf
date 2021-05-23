resource "aws_route_table" "terraform_pub_rt" {
  count = "${length(var.public_subnet_cidr_block)}"
  vpc_id = "${aws_vpc.terraform_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    #cidr_block = "111.223.27.153/32"
    gateway_id = "${aws_internet_gateway.terraform_gw.id}"
  }

  tags = {
    Name = "${element(var.public_rt_names,count.index)}"
  }
}

resource "aws_route_table_association" "rt_association_with_pub_subnets" {
  count = "${length(var.public_subnet_cidr_block)}"
  subnet_id      = "${element(aws_subnet.terraform_pub_subnet.*.id,count.index)}"
  #route_table_id = "${element(aws_route_table.terraform_pub_rt.id)}"
  route_table_id = "${aws_route_table.terraform_pub_rt[count.index].id}"
}



resource "aws_route_table" "terraform_priv_rt" {
  count = "${length(var.private_subnet_cidr_block)}"
  vpc_id = "${aws_vpc.terraform_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    #cidr_block = "111.223.27.153/32"
    gateway_id = "${aws_nat_gateway.terraform_nat_gw.id}"
  }

  tags = {
    Name = "${element(var.private_rt_names,count.index)}"
  }
}

resource "aws_route_table_association" "rt_association_with_priv_subnets" {
  count = "${length(var.private_subnet_cidr_block)}"
  subnet_id      = "${element(aws_subnet.terraform_priv_subnet.*.id,count.index)}"
  #route_table_id = "${element(aws_route_table.terraform_priv_rt.id)}"
  route_table_id = "${aws_route_table.terraform_priv_rt[count.index].id}"
}

