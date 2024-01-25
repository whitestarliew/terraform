packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "subnet_id" {
  default = "subnet-0e23051180b8f38c5"
}

variable "security_group_id" {
  default = "sg-02ba61f91920e87ee"
}

variable "aws_region" {
  default = "us-east-1"
}

data "amazon-parameterstore" "ami_id" {
  name = "/dev/ec2/ami"
  region = "us-east-1"
}

source "amazon-ebs" "AmazonLinux2" {
  ami_name        = "my-ami-{{timestamp}}"
  instance_type   = "t2.micro"
  region          = "us-east-1"
  ssh_keypair_name = "testing_ami"
  ssh_username    = "ec2-user"  // Adjust if needed
  source_ami      = data.amazon-parameterstore.ami_id.value
  subnet_id       = "subnet-0e23051180b8f38c5"
}

build {
  name      = "amazonlinux2-ami"
  sources   = ["source.amazon-ebs.AmazonLinux2"]

  provisioner "shell" {
    inline = [
      "sudo chmod 755 /tmp/installation1.sh",
    ]
  }
}






