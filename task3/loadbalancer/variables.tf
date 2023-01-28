variable "vpcID" {
  type        = string
  description = "vpc id"
}

variable "instanceID"{
    type        = map
    description = "ec2 id"
}

variable "security_group" {
  type        = string
  description = "security group name"
}

variable "public_cidr" {
  type        = string
  description = "0.0.0.0/0"
}

variable "publicSubnet1" {
  type        = string
  description = "public subnet id 1"
}

variable "publicSubnet2" {
  type        = string
  description = "public subnet id 2"
}

variable "privateSubnet1" {
  type        = string
  description = "private subnet id 1"
}

variable "privateSubnet2" {
  type        = string
  description = "private subnet id 2"

}
variable "port80" {
  type        = number
  description = "port 80"

}

variable "target_type" {
  type        = string
  description = "type is instance (default)"

}

variable "protocol" {
  type        = string
  description = "protocol is http"

}

variable target_group {
  type        = map
  description = "target group arguments"
}

