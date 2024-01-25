
output "VPC_output" {
    value = aws_vpc.testing-vpc.id
}

output "public_subnet_id_output" {
    value = aws_subnet.public_subnet.id  
}
