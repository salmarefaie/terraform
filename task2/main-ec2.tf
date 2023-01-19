resource "aws_security_group" "SG" {
  name        = var.security_group
  description = var.security_group
  vpc_id      = aws_vpc.vpc.id

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

resource "aws_instance" "public-ec2" {
  ami                         = var.ami
  instance_type               = var.ec2_type
  subnet_id                   = aws_subnet.subnet[0].id
  associate_public_ip_address = true
  vpc_security_group_ids             = [aws_security_group.SG.id]


  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  EOF

  tags = {
    Name = var.public_ec2_name
  }
}

resource "aws_instance" "private-ec2" {
  ami                         = var.ami
  instance_type               = var.ec2_type
  subnet_id                   = aws_subnet.subnet[1].id
  vpc_security_group_ids            = [aws_security_group.SG.id]



  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  EOF

  tags = {
    Name = var.private_ec2_name
  }
}

