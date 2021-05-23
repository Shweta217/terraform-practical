# This branch covers FE and BE approach in autoscaling group of EC2 instances behind application load balancer which is interacting with public subnet EC2 instances and load balancing on FE end.

ALB --> FE EC2 instances in pub subnet which is attached to internet gateway
to login to priv instnaces pub instances can be used
FE connects with BE instances as priv instances route is coming from prub route table

vpc is attached with igw

sg, pub and priv subnet is attached to vpc


pub subnet is attached with nat gateway

alb is attached to pub subnet and sg
alb target group is created in same respective vpc
alb target group attachment is attached with public EC2 instances containing FE webapp
alb listener set up with taking target_group_arn value as alb target group arn

asg launch config is done with two resources as : "aws_launch_configuration" and "aws_autoscaling_group"
pub new route created is taking source route from pub subnet
priv new route created is taking source route from priv subnet
