packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_region" {
  default = "us-east-1"
}

source "amazon-ebs" "Debian" {
  ami_name      = "my-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = var.aws_region
  ssh_username  = "ec2_user"
  source_ami    = var.image_id
}

build {
  name    = "debian-ami"
  sources = ["source.amazon-ebs.Debian"]"

  provisioner "file" {
    source = "installation1.sh"
    destination = "/tmp/installation1.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo chmod 755 /tmp/installation1.sh",
    ]
  }
}






