terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15" 
    }
  }
}

provider "aws" {
  region = var.aws_region 
}


resource "aws_ecr_repository" "sample_ect" {
  name                 = "testing_ecr_1"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}