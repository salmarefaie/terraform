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

# # data source ami
# data "aws_ami" "ubuntu-image" {
#   most_recent      = true
#   owners           = ["099720109477"]  

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
#   }
# }

# ec2
resource "aws_instance" "public-ec2" {
  ami                         =  "ami-00874d747dde814fa"                                   # data.aws_ami.ubuntu-image.image_id
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

  # provisioner "local-exec" {
  #       command = "echo ${each.key} ${self.private_ip} >> ./all-ips.txt"
  #       command = "echo ${each.key} ${self.public_ip} >> ./all-ips.txt"

      
  #   }
  #   provisioner "remote-exec" {
  #       inline = [
  #       "sudo apt update -y",
  #       "sudo apt install -y nginx",
  #       # "echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  server_name _; \n  location / { \n  proxy_pass http://${var.alb-2-dns-name}; \n  } \n}' > default",
  #       # "sudo mv default /etc/nginx/sites-enabled/default",
  #       "sudo systemctl stop nginx",
  #       "sudo systemctl start nginx"
  #       ]
  #   }
  tags = {
    Name = each.key
  }
}
