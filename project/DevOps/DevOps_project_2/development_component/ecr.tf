resource "aws_ecr_repository" "ralston_sample_ecr" {
  name                 = "sample-ecr-${formatdate("YYYY", timestamp())}"
  image_tag_mutability = "MUTABLE"
  force_delete         = false
  tags = {
    Name = "Testing for Regov"
    Env  = "staging"

  }
  image_scanning_configuration {
    scan_on_push = false
  }
  depends_on = [ aws_s3_bucket.regov_example ]
}