# s3-bucket-module/main.tf
provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name
  # acl    = "private"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_iam_role" "s3_role" {
  name               = "admin-access-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


output "output_aws_s3" {
  description = "output for route table"
  value       = aws_s3_bucket.example.id
}