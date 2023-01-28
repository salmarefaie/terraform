# target group
resource "aws_lb_target_group" "target-group" {
  target_type = var.target_type  
  for_each = var.target_group             
  name        = each.value
  port        = var.port80
  protocol    = var.protocol
  vpc_id      = var.vpcID
  
  health_check {
    path = "/"
    port = var.port80
  }
}

# attach instances to target group
resource "aws_lb_target_group_attachment" "ec2-target-group" {
  for_each = var.instanceID
  target_group_arn = each.value.targetGroup
  target_id = each.value.ec2
}

# security group for ec2
resource "aws_security_group" "loadbalancer_sg" {
  name        = var.security_group
  description = var.security_group
  vpc_id      = var.vpcID

  ingress {
    description = var.protocol
    from_port   = var.port80
    to_port     = var.port80
    protocol    = "tcp"
    cidr_blocks = [var.public_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.public_cidr]
  }

  tags = {
    Name = var.security_group
  }
}

#load balancer
resource "aws_lb" "alb" {
  load_balancer_type = var.load_balancer_type
  for_each = var.load_balancer
  name               = each.key
  internal           = each.value.internal     
  ip_address_type = var.ip_address_type

  security_groups    = [aws_security_group.loadbalancer_sg.id]
  subnets            = each.value.subnets

}

# listner
resource "aws_lb_listener" "alb_listner" {
  for_each = var.listener
  load_balancer_arn = each.value.loadBalancerArn
  port              = var.port80
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = each.value.targetGroupArn
  }
}













