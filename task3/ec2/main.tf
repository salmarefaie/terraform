# security group for ec2
resource "aws_security_group" "ec2_sg" {
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

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
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

# data source ami
data "aws_ami" "ubuntu-image" {
  most_recent      = true
  owners           = ["099720109477"]  

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
}

# ec2
resource "aws_instance" "public-ec2" {
  ami                         = data.aws_ami.ubuntu-image.image_id
  for_each = var.ec2_subnet
  instance_type               = var.ec2_type
  subnet_id                   = each.value
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]


  user_data = <<-EOF
  #!/usr/bin/bash
   sudo apt update -y
   sudo apt install nginx -y
   sudo systemctl enable --now nginx
  EOF

  tags = {
    Name = each.key
  }
}
