variable "security_group" {
  type        = string
  description = "security group name"
}

variable "public_cidr" {
  type        = string
  description = "0.0.0.0/0"
}

variable "vpcID" {
  type        = string
  description = "vpc id"
}

variable "ami" {
  type        = string
  description = "ami for ec2"
}

variable "ec2_type" {
  type        = string
  description = "instance type"
}

variable "public_ec2_subnet" {
  type        = map
  description = "instance arguments"
}

variable "private_ec2_subnet" {
  type        = map
  description = "instance arguments"
}

variable "private_alb_dns" {
  type        = string
  description = "private alb dns"
}
