variable "ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-01e5ff16fd6e8c542"
}

variable "default_vpc_id" {
  description = "ID of the default VPC"
  type        = string
  default     = "default-vpc"
  sensitive   = false
}
variable "instance_type" {
  description = "This is a instance type"
  type        = string
  default     = "t2.micro"

}

variable "aws_region" {
  description = "This is for AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "availability_zone" {
  description = "for availability zone"
  type        = string
  default     = "us-east-1a"
}
variable "subnet_id" {
  description = "This is a default subnet id"
  type        = string
  default     = "subnet-1a"

}

variable "private_subnet_id" {
  description = "existing subnet for private instance"
  type        = map(string)
  default = {
    private = "private-subnet"
    public  = "public-subnet"
  }
}

variable "private_subnet_cidr" {
  description = "existing subnet for private instance"
  type        = list(string)
  default     = ["172.31.36.0/24", "0.0.0.0/0"]
}

variable "public_cidr" {
  description = "existing subnet for private instance"
  type        = string
  default     = "0.0.0.0/0"

}