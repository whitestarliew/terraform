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

#security group
resource "aws_security_group" "second_sg_group" {
  name        = "second-security-group"
  description = "Second security group"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  output_route_table = aws_route_table.private_route_table.id
}
