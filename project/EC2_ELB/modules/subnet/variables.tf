variable "default_vpc_id" {
  description = "ID of the default VPC"
  type        = string
  default     = "default-vpc"
}

variable "availability_zone" {
  description = "for availability zone"
  type        = map(string)
  default     = {
    first  = "us-east-1a"
    second = "us-east-1b"
  }
}

variable "private_subnet_cidr" {
  description = "existing subnet for private instance"
  type        = string
  default     = "172.31.35.0/24"
}

variable "output_route_table" {
  description = "output from the parent module"
  type        = string
}