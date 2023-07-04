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
}

build {
  name    = "example-ami"
  sources = ["source.amazon-ebs.example"]
}
