provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Image recipe
resource "aws_imagebuilder_image_recipe" "linux_recipe" {
  name          = "linux-2"
  version       = "1.0.1"
  description   = "This is a testing recipe."
  components {
    # Add components here if needed
  }
}

# Base image
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]  # Replace with the specific Amazon Linux image you own
  }
}

# Infrastructure configuration (optional, adjust as needed)
resource "aws_imagebuilder_infrastructure_configuration" "linux_infra" {
  name          = "linux-infra"
  description   = "Infrastructure configuration for Linux pipeline"
  instance_types = ["t3.small"]
  subnet_id      = "subnet-xxxxxxxx"  # Replace with your subnet ID
  security_group_ids = ["sg-xxxxxxxx"]  # Replace with your security group IDs
  logging {
    s3_logs {
      bucket_name = "my-image-builder-logs"  # Replace with your S3 bucket name
    }
  }
}

# Image pipeline
resource "aws_imagebuilder_image_pipeline" "linux_pipeline" {
  name                     = "testing-linux-pipeline"
  description              = "This is a testing pipeline for Linux"
  enhanced_image_metadata_enabled = true
  image_recipe_arn         = aws_imagebuilder_image_recipe.linux_recipe.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.linux_infra.arn
  schedule {
    pipeline_execution_start_condition {
      expression = "MANUAL"
    }
  }
  tags = {
    name = "testing"
  }
  distribution_configuration {
    region = "us-east-1"  # Replace with your desired distribution region
  }
}
