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

variable "ec2_type" {
  type        = string
  description = "instance type"
}

variable "ec2_subnet" {
  type        = map
  description = "instance arguments"
}