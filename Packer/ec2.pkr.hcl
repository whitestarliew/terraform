packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "block-storage" {
  ami_name      = "my-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-west-2"
  source_ami    = "ami-12345678" #Replace with the AMI ID 
  ssh_username  = "admin"
}

build {
  name    = "example-ami"
  sources = ["source.amazon-ebs.block-storage"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y git",
      "wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh",
      "bash /tmp/miniconda.sh -b -p /opt/miniconda",
      "echo 'export PATH=/opt/miniconda/bin:$PATH' >> /etc/profile",
      "source /etc/profile"
    ]
  }
}





