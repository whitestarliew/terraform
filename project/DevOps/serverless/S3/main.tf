terraform {
  
}

provider "aws" {
    region = var.aws_region  
}

resource "aws_s3_bucket" "sample_bucket" {
    name = abec 
  
}