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

resource "aws_s3_bucket" "example" {
  bucket = "my-rl-test-bucket-${formatdate("YYYYMMDDHHMM", timestamp())}"
  object_lock_enabled = false

  tags = {
    Name        = "For the testing"
    Environment = "Dev"
  }
}