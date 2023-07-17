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

# Subnet Configuration
resource "aws_subnet" "private_subnet" {
  vpc_id                  = var.default_vpc_id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.aws_region
  map_public_ip_on_launch = false
}

# Route Table Configuration
resource "aws_route_table" "private_route_table" {
  vpc_id = var.default_vpc_id
}

# Route Configuration
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = var.public_cidr
  nat_gateway_id         = module.nat_gateway
}

# Private Subnet Association Configuration
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

#EC2 instance
resource "aws_instance" "private_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  /* associate_public_ip_address = true */
  key_name = "terraform"


  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  vpc_security_group_ids = ["sg-05ad0399a6c5dd340"] // Replace with your desired security group ID

  tags = {
    Name = "private Instance"
  }

  depends_on = [module.nat_gateway]
}


/*resource "aws_key_pair" "terraform" {
	key_name = "terraform"
	public_key = file("~/IT_Code/terraform.pem")
}*/

# output "bastion_public_ip" {
#   value = aws_instance.bastion_host.public_ip
# }


=======
#Module S3 Bucket
>>>>>>> 233a7b10be4c3dd1eeb40a6c5f21e39b521da617
module "aws_s3_bucket" {
  source = "./modules"

}

module "nat_gateway" {
  source = "./modules/NAT_Gateway"
  name = "my-nat-gateway"
}