resource "aws_s3_bucket" "regov_example" {
  bucket = "regov-test-bucket-${formatdate("YYYYMMDDHHMM", timestamp())}"
  object_lock_enabled = false

  tags = {
    Name        = "For the testing"
    Environment = "staging"
  }
}
##Source Bucket 
resource "aws_s3_bucket_public_access_block" "codepipeline_bucket_pab" {
  bucket = aws_s3_bucket.regov_example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [ aws_s3_bucket.regov_example ]
}

#Target Bucket 
resource "aws_s3_bucket" "regov_example_target_bucket" {
  bucket = "regov-test-bucket-2-${formatdate("YYYYMMDDHHMM", timestamp())}"
  object_lock_enabled = false

  tags = {
    Name        = "For the target bucket "
    Environment = "staging"
  }
}