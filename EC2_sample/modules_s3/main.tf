# s3-bucket-module/main.tf

resource "aws_s3_bucket" "example_bucket" {
  bucket = var.bucket_name
  acl    = "private"
  # other bucket configuration...
}
