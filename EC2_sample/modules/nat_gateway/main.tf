resource "aws_nat_gateway" "terraform_nat" {
  allocation_id = aws_eip.terraform_nat.id
  subnet_id     = aws_subnet.terraform_nat.id

  tags = {
    Name = "gw NAT"
  }
