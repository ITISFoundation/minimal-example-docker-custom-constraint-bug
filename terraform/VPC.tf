
resource "aws_vpc" "dev-vpc" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = "10.0.0.0/16"
  enable_dns_hostnames                 = true
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  tags = {

    "Name" = "dev-vpc"
  }
}


resource "aws_subnet" "dev-subnet1" {
  availability_zone       = "us-east-1f"
  vpc_id                  = aws_vpc.dev-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.0.0/23"
  tags = {

    "Name" = "dev-subnet1"
  }
}


resource "aws_subnet" "dev-subnet2" {
  availability_zone       = "us-east-1a"
  vpc_id                  = aws_vpc.dev-vpc.id
  map_public_ip_on_launch = true
  cidr_block              = "10.0.2.0/23"
  tags = {

    "Name" = "dev-subnet2"
  }
}
resource "aws_route_table_association" "dev-rta2" {
  subnet_id      = aws_subnet.dev-subnet2.id
  route_table_id = aws_route_table.dev-route-table.id
}
resource "aws_route_table_association" "dev-rta1" {
  subnet_id      = aws_subnet.dev-subnet1.id
  route_table_id = aws_route_table.dev-route-table.id
}
