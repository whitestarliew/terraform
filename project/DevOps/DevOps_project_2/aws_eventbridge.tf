resource "aws_cloudwatch_event_rule" "regov_console" {
  name        = "capture-aws-sign-in"
  description = "Sample for the console"

  event_pattern = jsonencode({
    detail-type = [
      "AWS Console Sign In via CloudTrail"
    ]
  })
}

resource "aws_cloudwatch_event_target" "regov_sns" {
  rule      = aws_cloudwatch_event_rule.console.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.aws_logins.arn
  depends_on = [ aws_sns_topic.aws_logins,
                 aws_cloudwatch_event_rule.console ]
}

resource "aws_sns_topic" "aws_logins" {
  name = "aws-console-logins"
}

resource "aws_sns_topic_policy" "regov_sns" {
  arn    = aws_sns_topic.aws_logins.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}
