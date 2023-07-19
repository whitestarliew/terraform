resource "aws_nat_gateway" "terraform_nat" {
  allocation_id = aws_eip.terraform_nat.id
  subnet_id     = aws_subnet.terraform_nat.id

  tags = {
    Name = "New NAT for terraform"
  }

resource "aws_eip" "example" {
  vpc = true
}


output "output_NAT_Gateway" {
  description = "This is a output nat gateway"
  value = string  
}