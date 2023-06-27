variable "ami_id" {
    description = "AMI ID"
    type        = string
    default = "ami-01e5ff16fd6e8c542"
}

variable "default_vpc_id" {
  description = "ID of the default VPC"
  type        = string
  default     = "default-vpc"
}

variable instance_type {
    description = "This is a instance type"
    type        = string
    default     = "t2.micro"
  
}

variable aws_region {
    description = "This is for AWS Region"
    type = string
    default = "us-east-1"
}

variable subnet_id {
    description = "This is a default subnet id"
    type = string
    default = "subnet-1a"
  
}

variable "private_subnet_id" {
  description = "existing subnet for private instance"
  type        = string
  default     = "private-subnet"
}