terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  #profile = "your-profile-name"
  region = var.aws_region
}


data "aws_vpc" "default_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.default_vpc_id]
  }
}
# Subnet Configuration
resource "aws_subnet" "private_subnet" {
  vpc_id                  = data.aws_vpc.default_vpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
}


# Route Table Configuration
resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.default_vpc.id
}



# Route Configuration
# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private_route_table.id
#   destination_cidr_block = var.public_cidr
#   nat_gateway_id         = module.nat_gateway.nat_gateway.id
# }

# Private Subnet Association Configuration
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

#EC2 instance
resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.private_subnet_id.private_subnet_id
  /* associate_public_ip_address = true */
  key_name = "terraform"

  tags = {
    Name = "private Instance"
  }

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }

  vpc_security_group_ids = ["sg-05ad0399a6c5dd340"] // Replace with your desired security group ID
}



module "private_subnet_id" {
  source             = "./modules/subnet"
  default_vpc_id     = var.default_vpc_id
}
