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


# Route Table Configuration
resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.default_vpc.id
  tags = {
    Name = "private subnet route table"
  }
}

# Private Subnet Association Configuration
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = module.private_subnet_id.output_private_subnet_id
  route_table_id = aws_route_table.private_route_table.id
}

#EC2 instance
resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.private_subnet_id.output_private_subnet_id
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
