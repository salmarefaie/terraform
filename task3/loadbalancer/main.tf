# target group
resource "aws_lb_target_group" "alb-target-group" {
  target_type = "instance"                   # default = instance
  name        = "alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpcID
  
  health_check {
    path = "/"
    port = 80
  }
}

# attach instances to target group
resource "aws_lb_target_group_attachment" "alb-target-group1" {
  target_group_arn = aws_lb_target_group.alb-target-group.arn
  for_each = var.instanceID
  target_id        = each.value
}
# resource "aws_lb_target_group_attachment" "alb-target-group2" {
#   target_group_arn = aws_lb_target_group.alb-target-group.arn
#   target_id        = "i-0cbe9d5dd6e026be5"
# }

# security group for ec2
resource "aws_security_group" "loadbalancer_sg" {
  name        = var.security_group
  description = var.security_group
  vpc_id      = var.vpcID

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
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
  load_balancer_type = "application"
  name               = "alb"
  internal           = false     
  ip_address_type = "ipv4"

  security_groups    = [aws_security_group.loadbalancer_sg.id]
  subnets            = [ var.publicSubnet1,var.publicSubnet2 ]

}

# listner
resource "aws_lb_listener" "alb_listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }
}

