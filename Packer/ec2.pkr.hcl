packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.9"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

<<<<<<< HEAD
source "amazon-ebs" "Debian" {
  ami_name      = "my-ami-{{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  ssh_username  = "admin"
  source_ami    = var.image_id
=======
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
>>>>>>> d03bdc53dd18efb82f7b3ce7b1c6d0aba79a2303
}

build {
  name      = "amazonlinux2-ami"
  sources   = ["source.amazon-ebs.AmazonLinux2"]

  provisioner "shell" {
    inline = [
<<<<<<< HEAD
      "sudo apt-get update",
      "sudo apt-get install -y git",
      "wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh",
=======
      "curl -O https://dl.influxdata.com/influxdb/releases/influxdb2-2.7.4-1.x86_64.rpm",
      "sudo yum localinstall -y influxdb2-2.7.4-1.x86_64.rpm",
      "sudo service influxdb start",
      "sudo service influxdb status",
>>>>>>> d03bdc53dd18efb82f7b3ce7b1c6d0aba79a2303
    ]
  }

}
