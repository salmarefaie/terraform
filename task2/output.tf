output "ec2-public-ip" {
  value       = aws_instance.public-ec2.public_ip
  description = "public ip for public instance"
}

output "public-ec2-private-ip" {
  value       = aws_instance.public-ec2.private_ip
  description = "private ip for public instance"
}

output "private-ec2-private-ip" {
  value       = aws_instance.private-ec2.private_ip
  description = "private ip for private instance"
}
