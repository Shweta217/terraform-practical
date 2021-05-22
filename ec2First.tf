resource "aws_instance" "ec2_instance_1" {
  ami           = "ami-06a0b4e3b7eb7a300"
  instance_type = "t2.micro"
  subnet_id  = "${aws_subnet.terraform_subnet.id}"
  availability_zone = "${var.az}"
  vpc_security_group_ids = "${[aws_security_group.allow_ssh.id]}"
  key_name = "${var.key_pair}"
  associate_public_ip_address = "true"
  tags = {
    Name = "tf1"
  }

}
