terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15" 
    }
  }
}

module "vpc_module" {
    source = "./EKS_module"
  
}