
provider "aws" {
    region = var.aws_region  
}

resource "aws_s3_bucket" "sample_bucket" {
    name = abec92409484130 
    object_lock_enabled = false
    versioning {
      enabled = false
    }
}

resource "aws_s3_bucket_acl" "sample_acl" {
    bucket = aws_s3_bucket.sample_bucket
    acl = "private"
}