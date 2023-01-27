output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "public_ec2_id_1" {
  value = aws_instance.public-ec2["public_ec2_1"].id
}

output "public_ec2_id_2" {
  value = aws_instance.public-ec2["public_ec2_2"].id
}
