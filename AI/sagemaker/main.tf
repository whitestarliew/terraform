provider "aws" {
  region = "us-west-2"
}

resource "aws_sagemaker_notebook_instance" "example" {
  name             = "example-notebook-instance"
  instance_type    = "ml.t2.medium"
  role_arn         = aws_iam_role.example.arn
  lifecycle_config = aws_sagemaker_notebook_instance_lifecycle_configuration.example.name

  tags = {
    Name        = "example-notebook-instance"
    Environment = "dev"
  }
}

resource "aws_iam_role" "example" {
  name = "example-sagemaker-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sagemaker.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "example" {
  name = "example-lifecycle-config"

  on_create {
    content_base64 = base64encode("#!/bin/bash\necho 'Hello, SageMaker!'")
  }
}
