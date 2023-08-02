provider "aws" {
  region = var.aws_region
}

resource "aws_apigatewayv2_api" "example_api" {
  name          = "ralstonvm"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "example_stage" {
  api_id      = aws_apigatewayv2_api.example_api.id
  name        = "ralston_stage"
  auto_deploy = true
}

output "api_url" {
  value = aws_apigatewayv2_stage.example_stage.invoke_url
}
