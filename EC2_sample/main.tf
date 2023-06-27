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
  #access_key = ""
  #secret_key = ""
}


resource "aws_instance" "private_instance" {
  ami           = var.ami_id 
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_id
  /* associate_public_ip_address = true */
  key_name = "terraform"


  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  vpc_security_group_ids = ["sg-05ad0399a6c5dd340"] // Replace with your desired security group ID

  tags = {
    Name = "private Instance"
  }
}

# NAT Gateway Configuration
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet_id
}

/*resource "aws_key_pair" "terraform" {
	key_name = "terraform"
	public_key = file("~/IT_Code/terraform.pem")
}*/

# Bastion Host 
# resource "aws_instance" "bastion_host" {
#   ami           = var.ami_id 
#   instance_type = var.instance_type
#   subnet_id     = "subnet-0f70608e59bb5f6aa" // Replace with your desired subnet ID
#   associate_public_ip_address = true
#   key_name = "terraform"

#   root_block_device {
#     volume_size = 10
#     volume_type = "gp2"
#  }
#   tags = {
#   Name = "Example Instance"
#  }
# }


# output "bastion_public_ip" {
#   value = aws_instance.bastion_host.public_ip
# }

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id  
}