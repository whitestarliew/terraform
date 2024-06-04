variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Region for aws"
}

variable "description" {
  type        = string
  default     = "Regov Testing"
  description = "For Regov"
}

variable "environment" {
  type = string
  default = "staging"
  description = "For Regov"
  
}