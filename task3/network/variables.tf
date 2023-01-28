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

variable "subnet" {
  type        = map(any)
  description = "public subnets + private subnets"
}

variable "route_table" {
  type        = map(any)
  description = "route table"
}

variable "nat_gateway" {
  type        = string
  description = "nat gateway name"
}

variable "public_cidr" {
  type        = string
  description = "0.0.0.0/0"
}

variable "route" {
  type        = map(any)
  description = "route for route table"
}


variable "subnet_association" {
  type        = map(any)
  description = "route for route table"
}
