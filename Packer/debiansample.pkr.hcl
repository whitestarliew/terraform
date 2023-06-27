packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "amazon"
    }
  }
}

source "amazon-ebs" "debian" {
  ami_name      = "debian-git-miniconda-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "debian-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["379101102735"] # Official Debian account
  }
}

build {
  name    = "debian-git-miniconda"
  sources = ["source.amazon-ebs.debian"]

  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get install -y git",
      "wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh",
      "bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda3",
      "echo 'export PATH=/opt/miniconda3/bin:$PATH' >> /etc/profile"
    ]
  }
}
