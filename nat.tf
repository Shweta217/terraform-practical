resource "aws_nat_gateway" "terraform_nat_gw" {
  allocation_id = "${aws_eip.terraform_eip.id}"
  subnet_id     = "${aws_subnet.terraform_pub_subnet[0].id}"

  tags = {
    Name = "terraform_nat_gw"
  }
}
