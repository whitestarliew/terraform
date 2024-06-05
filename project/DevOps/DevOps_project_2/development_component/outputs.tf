output "S3_bucket" {
    description = "Output for S3"
    value = aws_s3_bucket.regov_example  
}

output "code_commit_output" {
    description = "Output for code commit "
    value = aws_codecommit_repository.test 
}