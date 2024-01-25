terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15" 
    }
  }
}

provider "aws" {
  region = "us-east-1"
  
}

module "eks_module" {
  source = "./EKS_module" 
}