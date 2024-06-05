resource "aws_iam_role" "regov_iam_role" {
  name               = "regov_iam_role_codebuild"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy" "example" {
  role   = aws_iam_role.regov_iam_role.name
  policy = data.aws_iam_policy_document.regov_example.json
}

resource "aws_codebuild_project" "regov_codebuild_project" {
  name          = "regov-test-project"
  description   = var.description
  build_timeout = 5
  service_role  = aws_iam_role.regov_iam_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
   location = aws_s3_bucket.regov_example.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "Regov_build_project"
      value = "SOME_VALUE1"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.regov_example.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/mitchellh/packer.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

#   vpc_config {
#     vpc_id = aws_vpc.example.id

#     subnets = [
#       aws_subnet.example1.id,
#       aws_subnet.example2.id,
#     ]

#     security_group_ids = [
#       aws_security_group.example1.id,
#       aws_security_group.example2.id,
#     ]
#   }

  tags = {
    Environment = "Staging"
  }
  depends_on = [ aws_codecommit_repository.test ]
}

