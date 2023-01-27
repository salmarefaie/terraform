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

# variable "publicEc2ID1" {
#   type        = string
#   description = "public ec2 id 1"
# }

# variable "publicEc2ID2" {
#   type        = string
#   description = "public ec2 id 2"

# }

