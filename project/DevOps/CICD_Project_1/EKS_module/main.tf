terraform {
  required_version = ">= 0.12"
}

provider "aws" {
    required_version = ">=3.0.0"
}

data "aws_vpc" "" {
  type        = "zip"
  output_path = "${path.module}/files/output.zip"

  source {
    content  = ""
    filename = ""
  }
}


resource "aws_eks_cluster" "example" {
  depends_on = [aws_cloudwatch_log_group.example]

  enabled_cluster_log_types = ["api", "audit"]
  name                      = var.cluster_names
}
