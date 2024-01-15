provider "aws" {
  region = var.region
}

resource "aws_imagebuilder_pipeline" "example" {
  name     = var.pipeline_name
  description = var.pipeline_description
  schedule = "cron(0 0 * * ? *)"  # Manual schedule
  tags = {
    Name = "testing"
  }
  enhanced_image_metadata_enabled = var.enhanced_metadata_collection
  image_recipe_arn = aws_imagebuilder_image_recipe.example.arn
  infrastructure_configuration_arn = aws_imagebuilder_infrastructure_configuration.example.arn
  distribution_configuration_arn = aws_imagebuilder_distribution_configuration.example.arn
  depends_on = [
    aws_imagebuilder_image_recipe.example,
    aws_imagebuilder_infrastructure_configuration.example,
    aws_imagebuilder_distribution_configuration.example
  ]  
}

resource "aws_imagebuilder_image_recipe" "example" {
  name = var.image_recipe_name
  version = var.image_recipe_version
  parent_image = "arn:aws:imagebuilder:${var.region}:aws:image/${var.base_image_name}"
  component {
    component_arn = "arn:aws:imagebuilder:${var.region}:aws:component/amazon-cloudwatch-agent-linux"
  }
  component {
    component_arn = "arn:aws:imagebuilder:${var.region}:aws:component/ebs-volume-usage-test-linux"
  }
  block_device_mapping {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      volume_size = var.storage_size
      volume_type = "gp2"
    }
  }
}

resource "aws_imagebuilder_infrastructure_configuration" "example" {
  name = "${var.pipeline_name}-infrastructure"
  description = "Infrastructure configuration for ${var.pipeline_name} pipeline"
  instance_profile_name = "testing-infra-config"
}

resource "aws_imagebuilder_distribution_configuration" "example" {
  name = "${var.pipeline_name}-distribution"
  description = "Distribution configuration for ${var.pipeline_name} pipeline"
  distribution {
    ami_distribution_configuration {
      ami_tags = {
        CostCenter = "testing"
      }

      name = "example-{{ imagebuilder:buildDate }}"

      launch_permission {
        user_ids = ["123456789012"]
      }
    }

    launch_template_configuration {
      launch_template_id = "lt-0aaa1bcde2ff3456"
    }

    region = var.aws_region
  }
}
