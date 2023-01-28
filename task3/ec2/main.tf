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
# data "aws_ami" "image" {
#   most_recent      = true
#   owners           = ["amazon"]  

#   filter {
#     name   = "name"
#     values = ["amzn-ami-hvm-*-x86_64-gp2"]
#   }
# }

# public ec2
resource "aws_instance" "public-ec2" {
  ami                         = var.ami                   # data.aws_ami.image.image_id
  for_each = var.public_ec2_subnet
  instance_type               = var.ec2_type
  subnet_id                   = each.value
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  key_name = "key"

  tags = {
    Name = each.key
  }

  #public ip
  provisioner "local-exec" {
        command = "echo 'public ip for ${each.key}: ${self.public_ip}' >> ./all-ips.txt"   
    }
  
  #private ip
  provisioner "local-exec" {
        command = "echo 'private ip for ${each.key}: ${self.private_ip}' >> ./all-ips.txt"   
    }

  provisioner "remote-exec" {
        inline = [
        "sudo apt update -y",
        "sudo apt install -y nginx",
        "echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  server_name _; \n  location / { \n  proxy_pass http://${var.private_alb_dns}; \n  } \n}' > default",
        "sudo mv default /etc/nginx/sites-enabled/default",
        "sudo systemctl stop nginx",
        "sudo systemctl start nginx"
        ]
    }
       
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = file("./key.pem")
        timeout = "4m"
    }
    
}


# private ec2
resource "aws_instance" "private-ec2" {
  ami                         = var.ami                 
  for_each = var.private_ec2_subnet
  instance_type               = var.ec2_type
  subnet_id                   = each.value
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install apache2 -y
  sudo systemctl start apache2
  sudo systemctl enable apache2
  EOF

  tags = {
    Name = each.key
  }

  # private ip
  provisioner "local-exec" {
        command = "echo 'private ip for ${each.key}: ${self.private_ip}' >> ./all-ips.txt"   
    }

# # basion host
# provisioner "remote-exec" {
#   inline = [
#         "sudo apt update -y",
#         "sudo apt install apache2 -y",
#         "sudo systemctl start apache2",
#         "sudo systemctl enable apache2"
#         ]       
#     }
# connection {
#         type = "ssh"
#         host = self.private_ip 
#         user = "ubuntu"
#         private_key = file("./key.pem")
#         bastion_host = aws_instance.public-ec2["public_ec2_1"].id
#         bastion_user = "ubuntu"
#         bastion_host_key = file("./key.pem")
#       } 

}
