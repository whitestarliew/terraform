resource "aws_iam_role" "regov_codepipeline_role" {
  name               = "test-role"
  assume_role_policy = data.aws_iam_policy_document.regov_assume_role_2.json
}


resource "aws_iam_role_policy" "regov_codepipeline_policy" {
  name   = "regov_codepipeline_policy"
  role   = aws_iam_role.regov_codepipeline_role.id
  policy = data.aws_iam_policy_document.regov_codepipeline_assume_role.json
}

# resource "aws_iam_role" "regov_iam_role" {
#   name               = "regov_iam_role_codebuild"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }


resource "aws_iam_role_policy" "regov_example" {
  role   = aws_iam_role.regov_iam_role.name
  policy = data.aws_iam_policy_document.regov_example.json
}