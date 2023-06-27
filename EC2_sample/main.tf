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
#profile = "liew-ralston"
  region = var.aws_region
  #access_key = ""
  #secret_key = ""
}


resource "aws_instance" "test1_instance" {
  ami           = var.ami_id // Replace with your desired AMI ID
  instance_type = var.instance_type
  subnet_id     = "subnet-0f70608e59bb5f6aa" // Replace with your desired subnet ID
  /* associate_public_ip_address = true */
  key_name = "terraform"


  root_block_device {
    volume_size = 80
    volume_type = "gp2"
  }

  vpc_security_group_ids = ["sg-05ad0399a6c5dd340"] // Replace with your desired security group ID

  tags = {
    Name = "Example Instance"
  }
}

# NAT Gateway Configuration
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = "YOUR_DEFAULT_SUBNET_ID"
}

/*resource "aws_key_pair" "terraform" {
	key_name = "terraform"
	public_key = file("~/IT_Code/terraform.pem")
}*/

# Bastion Host 
resource "aws_instance" "bastion_host" {
  ami           = var.ami_id // Replace with your desired AMI ID
  instance_type = var.instance_type
  subnet_id     = "subnet-0f70608e59bb5f6aa" // Replace with your desired subnet ID
  associate_public_ip_address = true
  key_name = "terraform"

  root_block_device {
    volume_size = 80
    volume_type = "gp2"
 }
  tags = {
  Name = "Example Instance"
 }
}


output "bastion_public_ip" {
  value = aws_instance.bastion_host.public_ip
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id  
}