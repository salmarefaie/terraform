variable "vpc_cidr" {
  type        = string
  description = "vpc cidr"
}

variable "vpc_name" {
  type        = string
  description = "vpc name"
}

variable "internet_gateway" {
  type        = string
  description = "internet gateway name"
}

variable "subnet_cidr" {
  type        = list(any)
  description = "public subnet cidr + private subnet cidr"
}

variable "subnet_name" {
  type        = list(any)
  description = "public subnet name + private subnet name"
}

variable "public_cidr" {
  type        = string
  description = "0.0.0.0/0"
}

variable "ipv6_cidr_block" {
  type        = string
  description = "ipv6 cidr block"
}

variable "public_routing_table" {
  type        = string
  description = "public routing table"
}

variable "private_routing_table" {
  type        = string
  description = "private routing table"
}

variable "nat_gateway" {
  type        = string
  description = "nat gateway name"
}

variable "security_group" {
  type        = string
  description = "security group name"
}

variable "ami" {
  type        = string
  description = "ami for ec2"
}

variable "ec2_type" {
  type        = string
  description = "instance type"
}

variable "public_ec2_name" {
  type        = string
  description = "public instance name"
}

variable "private_ec2_name" {
  type        = string
  description = "private instance name"
}