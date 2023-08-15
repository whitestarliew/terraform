provider "aws" {
  region = "eu-west-1"  # Set your desired AWS region (eu-west-1)
}

resource "aws_lambda_function" "sample_lambda" {
  function_name = "sample_lambda"
  handler      = "index.handler"
  runtime      = "nodejs14.x"
  filename     = "sample_lambda.zip"
  source_code_hash = filebase64sha256("sample_lambda.zip")  # Replace with the actual filename

  role = aws_iam_role.lambda_role.arn  # Assuming you have a role defined

  # Optional: Environment variables
  environment {
    variables = {
      ENV_VAR_KEY = "value"
    }
  }

  # Optional: Memory and timeout settings
  memory_size = 128
  timeout     = 10
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  # Attach necessary policies if required
}

# Assuming you have your Lambda function code in "sample_lambda.zip"
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "path/to/lambda/code"
  output_path = "sample_lambda.zip"
}

# Output the Lambda function ARN
output "lambda_arn" {
  value = aws_lambda_function.sample_lambda.arn
}
