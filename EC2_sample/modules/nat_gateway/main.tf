resource "aws_nat_gateway" "terraform_nat" {
  allocation_id = aws_eip.sample_eip.id
  subnet_id     = aws_subnet.terraform_nat.id

  tags = {
    Name = "New NAT for terraform"
  }

resource "aws_eip" "sample_eip" {
  vpc = true
}


output "output_NAT_Gateway_id" {
  description = "This is a output nat gateway"
  value = aws_nat_gateway.terraform_nat.id  
}