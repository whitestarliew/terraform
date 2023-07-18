#output



#output "s3_bucket_name" {
#  value = module.
#}

output "vpc_id" {
  description = "ID of the VPC"
  value       = data.aws_vpc.default_vpc.id
}

output "output_route_table" {
  description = "output for route table"
  value = aws_route_table.private_route_table.id
}