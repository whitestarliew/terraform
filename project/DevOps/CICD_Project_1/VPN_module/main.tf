provider "aws" {
  region = var.aws_region # Replace with your desired AWS region
}

data "aws_region" "current" {}

resource "aws_vpc" "testing-vpc" {
  cidr_block = "10.1.16.0/20"
  tags = {
    Name = "testing-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.testing-vpc.id
  tags = {
    Name = "sample_igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.testing-vpc.id
  cidr_block = cidrsubnet(aws_vpc.testing-vpc.cidr_block, 8, 1)
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1a"
  }
}

# Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.testing-vpc.id
  cidr_block = cidrsubnet(aws_vpc.testing-vpc.cidr_block, 8, 2)
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-subnet-1a"
  }
}

# Use existing Internet Gateway and Route Table (Replace with their resource IDs)
resource "aws_route_table" "existing_route_table" {
  vpc_id = aws_vpc.testing-vpc.id
  # Replace with the ID of your existing route table
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public_subnet_route_table_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.existing_route_table.id
}

# You don't need a route association for the private subnet if it doesn't need internet access.

# (Optional) Create a NAT Gateway for private subnet internet access
# resource "aws_nat_gateway" "private_subnet_nat_gateway" {
#   subnet_id = aws_subnet.private_subnet.id
#   allocation_id = aws_eip.nat_gateway_eip.allocation_id
# }

# (Optional) Add a route to the route table for private subnet access to NAT Gateway
# resource "aws_route" "private_subnet_nat_gateway_route" {
#   route_table_id = aws_route_table.existing_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.private_subnet_nat_gateway.id
# }

# Note: This is a basic configuration and may need adjustments based on your specific requirements.

