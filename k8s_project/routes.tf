# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route = [
#     {
#       cidr_block                 = "0.0.0.0/0"
#       nat_gateway_id             = aws_nat_gateway.nat.id
#       carrier_gateway_id         = ""
#       destination_prefix_list_id = ""
#       egress_only_gateway_id     = ""
#       gateway_id                 = ""
#       instance_id                = ""
#       ipv6_cidr_block            = ""
#       local_gateway_id           = ""
#       network_interface_id       = ""
#       transit_gateway_id         = ""
#       vpc_endpoint_id            = ""
#       vpc_peering_connection_id  = ""
#       core_network_arn           = "" 
#     },
#   ]

#   tags = {
#     Name = "private"
#   }
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route = [
#     {
#       cidr_block                 = "0.0.0.0/0"
#       gateway_id                 = aws_internet_gateway.igw.id
#       nat_gateway_id             = ""
#       carrier_gateway_id         = ""
#       destination_prefix_list_id = ""
#       egress_only_gateway_id     = ""
#       instance_id                = ""
#       ipv6_cidr_block            = ""
#       local_gateway_id           = ""
#       network_interface_id       = ""
#       transit_gateway_id         = ""
#       vpc_endpoint_id            = ""
#       vpc_peering_connection_id  = ""
#       core_network_arn           = ""   
#     },
#   ]

#   tags = {
#     Name = "public"
#   }
# }




# Routing table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "public"
  }
}

output "aws_route_table_public_ids" {
  value = aws_route_table.public.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id      = aws_subnet.public-us-east-1b.id
  route_table_id = aws_route_table.public.id
}



# Routing table for private subnets
resource "aws_route_table" "private" {
#   count  = var.multi_az_nat_gateway * var.az_count + var.single_nat_gateway * 1
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "private"
  }
}

output "aws_route_table_private_ids" {
  value = aws_route_table.private.id
}

resource "aws_route" "private_nat_gateway" {
#   count                  = var.multi_az_nat_gateway * var.az_count + var.single_nat_gateway * 1
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.nat.id
  destination_cidr_block = "0.0.0.0/0"
#   depends_on = [
#     aws_route_table.private,
#     aws_nat_gateway.nat_gateway,
#   ]
}

resource "aws_route_table_association" "private-us-east-1a" {
  subnet_id      = aws_subnet.private-us-east-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-us-east-1b" {
  subnet_id      = aws_subnet.private-us-east-1b.id
  route_table_id = aws_route_table.private.id
}

