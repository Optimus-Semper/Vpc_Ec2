# Create VPC
resource "aws_vpc" "VPC2025" {
    cidr_block = "172.120.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "UTC-App"
      Team = "Cloud Team 2025"
      created_by = "Victor Okwologu"
    }
}

# Internet Gateway
resource "aws_internet_gateway" "Gateway" {
  vpc_id = aws_vpc.VPC2025.id
}

# Public Subnet
resource "aws_subnet" "Public-Subnet1" {
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.VPC2025.id
  cidr_block = "172.120.1.0/24"
map_public_ip_on_launch = true
}
resource "aws_subnet" "Public-Subnet2" {
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.VPC2025.id
  cidr_block = "172.120.2.0/24"
map_public_ip_on_launch = true
}
# Private Subnet
resource "aws_subnet" "Private-Subnet1" {
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.VPC2025.id
  cidr_block = "172.120.3.0/24"
}
resource "aws_subnet" "Private-Subnet2" {
  availability_zone = "us-east-1b"
  vpc_id = aws_vpc.VPC2025.id
  cidr_block = "172.120.4.0/24"
}

# Create Nat-gateway
resource "aws_eip" "Elastic-IP-1" {}

resource "aws_nat_gateway" "NatGateway1" {
  allocation_id = aws_eip.Elastic-IP-1.id
  subnet_id = aws_subnet.Public-Subnet1.id
}
# Create Private Route Table
resource "aws_route_table" "Private-Route-Table" {
  vpc_id = aws_vpc.VPC2025.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NatGateway1.id
  }
}

# Create Public Route Table
resource "aws_route_table" "Public-Route-Table" {
  vpc_id = aws_vpc.VPC2025.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Gateway.id
  }
}

# Create Public Route Table Association
resource "aws_route_table_association" "Public-Route1" {
  subnet_id = aws_subnet.Public-Subnet1.id
  route_table_id = aws_route_table.Public-Route-Table.id

}
resource "aws_route_table_association" "Public-Route2" {
  subnet_id = aws_subnet.Public-Subnet2.id
  route_table_id = aws_route_table.Public-Route-Table.id
}

# Create Private Route Table Association
resource "aws_route_table_association" "Private-Route1" {
  subnet_id = aws_subnet.Private-Subnet1.id
  route_table_id = aws_route_table.Private-Route-Table.id

}
resource "aws_route_table_association" "Private-Route2" {
  subnet_id = aws_subnet.Private-Subnet2.id
  route_table_id = aws_route_table.Private-Route-Table.id

}