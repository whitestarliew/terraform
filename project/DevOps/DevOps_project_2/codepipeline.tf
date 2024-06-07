#Code Pipeline
resource "aws_codepipeline" "regov_codepipeline" {
  name     = "regov-pipeline"
  role_arn = aws_iam_role.regov_codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.regov_example.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeCommit"
      namespace        = "SourceVariables"
      output_artifacts = ["source_output"]
      run_order        = 1

      configuration = {
        RepositoryName       = aws_codecommit_repository.test.repository_name
        BranchName           = "main"
        PollForSourceChanges = "true"
      }
    }
  }
  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "Regov-test"
      }
    }
  }
  depends_on = [ aws_codebuild_project.regov_codebuild_project,
                 aws_codecommit_repository.test ]
}
