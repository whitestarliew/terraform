output "S3_bucket_source_bucket" {
    description = "Output for S3"
    value = aws_s3_bucket.regov_example  
}

output "code_commit_output" {
    description = "Output for code commit "
    value = aws_codecommit_repository.test 
}


output "code_build_output" {
    description = "Output for code build "
    value = aws_codebuild_project.regov_codebuild_project 
}


output "codepipeline_output" {
    description = "Output for Pipeline "
    value = aws_codepipeline.regov_codepipeline 
}