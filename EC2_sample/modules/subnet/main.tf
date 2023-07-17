resource "aws_subnet" "private_subnet" {
  vpc_id                  = var.default_vpc_id
  cidr_block              = "172.31.35.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}