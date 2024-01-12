source "amazon-ebs" "my-ami" {
  ami_name    = "{{timestamp}}"
  region      = "eu-west-2"
  instance_type = "t3.micro"  // Multiple types can be specified as a list
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"  // General Linux 2 filter
      owner-alias         = "amazon"
      virtualization-type = "hvm"
    }
    most_recent = true
  }
  ssh_username = "ec2-user"

  # Retrieve base AMI ID from SSM Parameter Store
  dynamic "source_ami" {
    for_each = toset(["/ab/CorpAMI/Amazon2"])
    content {
      value = aws_ssm_parameter.base_ami[source.key].value
    }
  }

  # Use variables for VPC and subnet
  vpc_id       = var.vpc_id
  subnet_id    = var.subnet_id

  # User data from a separate shell script
  user_data_file = "user_data.sh"
}

# Define variables
variable "vpc_id" {}
variable "subnet_id" {}

# Fetch base AMI ID from SSM Parameter Store
data "aws_ssm_parameter" "base_ami" {
  for_each = toset(["/ab/CorpAMI/Amazon2"])
  name     = each.value
}

# Provisioner for installing InfluxDB (optional)
provisioner "shell" {
  inline = ["sudo yum install influxdb -y"]
}
