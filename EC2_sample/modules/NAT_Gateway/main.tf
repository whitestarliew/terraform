provider "aws" {
  region = "us-east-1"
}

# NAT Gateway Configuration
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = cidrsubnet(data.aws_vpc.default.cidr_block, 4, 0)
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet"
  }
}
#output
output "nat_gateway" {
    value = aws_nat_gateway.nat_gateway.id
}
