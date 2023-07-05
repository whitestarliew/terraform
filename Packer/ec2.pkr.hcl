packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "Debian" {
  ami_name      = "my-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  ssh_username  = "admin"
  source_ami    = "ami-0ba3123355c7d55d3"
}

build {
  name    = "debian-ami"
  sources = ["source.amazon-ebs.Debian"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y git",
      "wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh",
      "sudo bash /tmp/miniconda.sh -b -p /opt/miniconda",
      "echo 'export PATH=/opt/miniconda/bin:$PATH' | sudo tee -a /etc/profile",
      ". /etc/profile"
    ]
  }
}






