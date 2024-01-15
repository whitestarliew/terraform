resource "aws_subnet" "private_subnet" {
  vpc_id                  = "vpc-0d6865588bb47232b"
  cidr_block              = var.private_subnet_cidr
  availability_zone       = var.availability_zone["first"]
  map_public_ip_on_launch = false
}

# Private Subnet Association Configuration
#testing
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = var.output_route_table

}

module "nat_gateway_id" {
  source             = "./modules/nat_gateway"
}



output "output_private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}