resource "aws_instance" "pub_ec2s" {
  count = "${length(var.public_ec2_names)}"
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id  = "${aws_subnet.terraform_pub_subnet[count.index].id}"
  availability_zone = "${element(var.availability_zones,count.index)}"
  vpc_security_group_ids = "${[aws_security_group.terraform_sg.id]}"
  key_name = "${var.key_pair}"
  associate_public_ip_address = "true"
  tags = {
    #Name = "${element(var.public_ec2_names,count.index)}"
    Name = "${format("pub_ec2_%d",count.index+1)}"
  }
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd.service
                systemctl enable httpd.service
                echo "Hi Friend I am public EC2!!!! : $(hostname -f)" > /var/www/html/index.html
                EOF
}

resource "aws_instance" "priv_ec2s" {
  count = "${length(var.private_ec2_names)}"
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  subnet_id  = "${aws_subnet.terraform_priv_subnet[count.index].id}"
  availability_zone = "${element(var.availability_zones,count.index)}"
  vpc_security_group_ids = "${[aws_security_group.terraform_sg.id]}"
  key_name = "${var.key_pair}"
  tags = {
    Name = "${element(var.private_ec2_names,count.index)}"
  }
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd.service
                systemctl enable httpd.service
                echo "Hi Friend I am private EC2!!!! : $(hostname -f)" > /var/www/html/index.html
                EOF
}




