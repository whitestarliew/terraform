terraform {
  required_version = ">= 0.12"
}

provider "aws" {
    required_version = ">=3.0.0"
}

resource "aws_eks"