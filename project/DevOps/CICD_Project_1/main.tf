terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15" 
    }
  }
}

module "eks_module" {
  source = ".//EKS_module"
  clustercluster_name = "testing-eks"  
}