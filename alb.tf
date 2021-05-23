########## alb creation ##############
resource "aws_lb" "terraform_alb" {
  name               = "terraformAlb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.terraform_sg.id}"]
  subnets            = "${aws_subnet.terraform_pub_subnet.*.id}"
  tags = {
    Environment = "terraform_alb"
  }
}

####### alb target group set up ##########
resource "aws_lb_target_group" "terraform_alb_target_group" {
  name     = "terraformAlbTargetGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.terraform_vpc.id}"
  health_check {
    path = "/"
    port = "80"
    protocol = "HTTP"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 4
    interval            = 5
    matcher = "200"
  }
}

#### ~~~~ alb pub target group attachment ~~~ ###
resource "aws_lb_target_group_attachment" "terraform_alb_pub_target_group_attachment" {
  #count = "${length(var.public_subnet_cidr_block)}"
  count = "${length(aws_instance.pub_ec2s)}"
  target_group_arn = aws_lb_target_group.terraform_alb_target_group.arn
  target_id        = "${element(aws_instance.pub_ec2s.*.id,count.index)}"
  port             = 80
  }



########### alb listener set up ###############
resource "aws_lb_listener" "terraform_listener_front_end" {
  load_balancer_arn = aws_lb.terraform_alb.arn
  port              = "80"
  protocol          = "HTTP"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraform_alb_target_group.arn
  }
}



