# vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.internet_gateway
  }
}

# public subnet + private subnet
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  count      = length(var.subnet_cidr)
  cidr_block = var.subnet_cidr[count.index] # 0:public , 1:private

  tags = {
    Name = var.subnet_name[count.index]
  }
}

# public routing table + route
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.gateway.id
  }

  route {
    ipv6_cidr_block = var.ipv6_cidr_block
    gateway_id      = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = var.public_routing_table
  }
}

# public subnet association
resource "aws_route_table_association" "public-subnet-route" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.public-route-table.id
}

# private routing table + route
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.private_routing_table
  }
}

# private subnet association
resource "aws_route_table_association" "private-subnet-route" {
  subnet_id      = aws_subnet.subnet[1].id
  route_table_id = aws_route_table.private-route-table.id
}

#elastic ip
resource "aws_eip" "eip-nat" {
  vpc = true
}

# nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.subnet[0].id

  tags = {
    Name = var.nat_gateway
  }

  depends_on = [aws_internet_gateway.gateway]
}