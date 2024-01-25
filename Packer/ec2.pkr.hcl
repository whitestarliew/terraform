packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.9"
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
  name   = "/dev/ec2/ami"
  region = "us-east-1"
}

source "amazon-ebs" "AmazonLinux2" {
  ami_name             = "my-ami-{{timestamp}}"
  instance_type        = "t2.micro"
  region               = "us-east-1"
  ssh_agent_auth       = true
  ssh_username         = "ec2-user" 
  source_ami           = data.amazon-parameterstore.ami_id.value
  subnet_id            = var.subnet_id
  security_group_id    = var.security_group_id
}

build {
  name    = "amazonlinux2-ami"
  sources = ["source.amazon-ebs.AmazonLinux2"]

  provisioner "shell" {
    inline = [
      "curl -O https://dl.influxdata.com/influxdb/releases/influxdb2-2.7.4-1.x86_64.rpm",
      "sudo yum localinstall -y influxdb2-2.7.4-1.x86_64.rpm",
      "sudo service influxdb start",
      "sudo service influxdb status",
    ]
  }

}
