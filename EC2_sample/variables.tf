variable "ami_id" {
    description = "AMI ID"
    type        = string
    default = "ami-01e5ff16fd6e8c542"
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

