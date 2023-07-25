provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "testing_vpc" {
  cidr_block = "10.1.5.0/24"
}

resource ""

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}