data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "regov_example" {
  statement {
    effect = "Allow"
    actions = ["codepipeline:*"]
    resources = ["arn:aws:codepipeline:us-east-2:*:codepipeline/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["codecommit:*"]
    resources = ["arn:aws:codecommit:us-east-2:*:codecommit/*"]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = ["*"]
  }
}

# data "aws_kms_alias" "s3kmskey" {
#   name = "alias/myKmsKey"
# }

data "aws_iam_policy_document" "regov_codepipeline_assume_role" {

  statement {
    effect    = "Allow"
    actions   = ["codecommit:*"]
    resources = ["arn:aws:codecommit:us-east-1:*:codecommit/*"]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:*"]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "regov_assume_role_2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


###SNS Topic 
data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.aws_logins.arn]
  }
}