######### launch configuration ##########
resource "aws_launch_configuration" "terraform_asg_launch_config" {
  name_prefix   = "terraform-asg-"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  security_groups = ["${aws_security_group.terraform_sg.id}"]
  key_name = "${var.key_pair}"
  associate_public_ip_address = "true"
  user_data = <<-EOF
                #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd.service
                systemctl enable httpd.service
                echo "Hi Friend I am public EC2 launched from Autoscaling!!!! : $(hostname -f)" > /var/www/html/index.html
                EOF
  
  lifecycle {
    create_before_destroy = true
  }
}


##### asg ####
resource "aws_autoscaling_group" "terraform_asg" {
  name                      = "terraform_asg"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.terraform_asg_launch_config.name
  vpc_zone_identifier       = "${aws_subnet.terraform_pub_subnet.*.id}"

  lifecycle {
    create_before_destroy = true
  }
}
