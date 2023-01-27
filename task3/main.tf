module "network" {
  source           = "./network"
  vpc_cidr         = "10.0.0.0/16"
  vpc_name         = "my vpc"
  internet_gateway = "internet gateway"
  nat_gateway      = "nat"
  public_cidr      = "0.0.0.0/0"

  subnet = {
    "public_subnet1"  = { cidr = "10.0.0.0/24", zone = "us-east-1b" },
    "public_subnet2"  = { cidr = "10.0.2.0/24", zone = "us-east-1c" },
    "private_subnet1" = { cidr = "10.0.1.0/24", zone = "us-east-1b" },
    "private_subnet2" = { cidr = "10.0.3.0/24", zone = "us-east-1c" }
  }

  route_table = {
    "public_name"  = "public route table",
    "private_name" = "private route table"
  }

  route = {
    "route1" = { routingTableID = module.network.public_route_table_id, gatewayID = module.network.gateway_id },
    "route2" = { routingTableID = module.network.private_route_table_id, gatewayID = module.network.nat_id }
  }

  subnet_association = {
    "publicSubnet_association1"  = { subnetID = module.network.public_subnet1_id, routingTableID = module.network.public_route_table_id },
    "publicSubnet_association2"  = { subnetID = module.network.public_subnet2_id, routingTableID = module.network.public_route_table_id },
    "privateSubnet_association1" = { subnetID = module.network.private_subnet1_id, routingTableID = module.network.private_route_table_id },
    "privateSubnet_association2" = { subnetID = module.network.private_subnet2_id, routingTableID = module.network.private_route_table_id }
  }
}

module "ec2" {
  source         = "./ec2"
  public_cidr    = "0.0.0.0/0"
  security_group = "ec2 security group"
  vpcID          = module.network.vpc_id
  ec2_type              = "t2.micro"

  ec2_subnet = {
    "public_ec2_1"  = module.network.public_subnet1_id,
    "public_ec2_2"  = module.network.public_subnet2_id
  }

}

module "loadbalancer" {
  source         = "./loadbalancer"
  vpcID          = module.network.vpc_id

  instanceID = {
    "public_ec2_id_1"  = module.ec2.public_ec2_id_1,
    "public_ec2_id_2"  = module.ec2.public_ec2_id_2
  }
  
  security_group = "loadBalancer security group"
  public_cidr    = "0.0.0.0/0"
  publicSubnet1 = module.network.public_subnet1_id
  publicSubnet2 = module.network.public_subnet2_id

  # publicEc2ID1 = module.ec2.public_ec2_id_1      
  # publicEc2ID2 = module.ec2.public_ec2_id_2

  }




