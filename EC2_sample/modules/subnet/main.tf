resource "aws_subnet" "private_subnet" {
  vpc_id                  = "vpc-0d6865588bb47232b"
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}