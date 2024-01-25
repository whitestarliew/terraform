
output "VPC_output" {
    value = aws_vpc.testing-vpc.id
}

output "public_subnet_id_output" {
    value = aws_subnet.public_subnet.id  
}

output "private_subnet_id_output" {
    value = aws_subnet.private_subnet.id  
}

output "public_subnet_id_2_output" {
    value = aws_subnet.public_subnet_2.id  
}
