# resource "aws_cloudwatch_event_rule" "console" {
#   name        = "capture-aws-sign-in"
#   description = "Capture each AWS Console Sign In"

#   event_pattern = jsonencode({
#     detail-type = [
#       "AWS Console Sign In via CloudTrail"
#     ]
#   })
# }

# resource "aws_cloudwatch_event_target" "sns" {
#   rule      = aws_cloudwatch_event_rule.console.name
#   target_id = "SendToSNS"
#   arn       = aws_sns_topic.aws_logins.arn
# }

# resource "aws_sns_topic" "aws_logins" {
#   name = "aws-console-logins"
# }

# resource "aws_sns_topic_policy" "default" {
#   arn    = aws_sns_topic.aws_logins.arn
#   policy = data.aws_iam_policy_document.sns_topic_policy.json
# }
