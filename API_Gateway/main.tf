provider "aws" {
  region = "eu-west-2"
}

# Your existing Amazon Cognito User Pool ARN
variable "cognito_user_pool_arn" {
  default = "YOUR_EXISTING_USER_POOL_ARN"
}

# Step 1: Create an API Gateway
resource "aws_api_gateway_rest_api" "example" {
  name = "MyApi"
}

resource "aws_api_gateway_resource" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "myresource"
}

resource "aws_api_gateway_method" "example" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.example.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"  # Use Cognito User Pools for authorization
}

resource "aws_api_gateway_integration" "example" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.example.id
  http_method             = aws_api_gateway_method.example.http_method
  integration_http_method = "GET"
  type                    = "HTTP"
  uri                     = "https://example.com"
}

resource "aws_api_gateway_method_response" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.example.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example.id
  http_method = aws_api_gateway_method.example.http_method
  status_code = aws_api_gateway_method_response.example.status_code
}

# Create the Cognito User Pool Authorizer using the existing User Pool ARN
resource "aws_api_gateway_authorizer" "example" {
  name                   = "MyUserPoolAuthorizer"
  rest_api_id             = aws_api_gateway_rest_api.example.id
  type                   = "COGNITO_USER_POOLS"
  identity_source        = "method.request.header.Authorization"
  provider_arns          = [var.cognito_user_pool_arn]  # Use the existing User Pool ARN
}

# Attach the Authorizer to the Method
resource "aws_api_gateway_method_settings" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "dev"
  method_path = aws_api_gateway_resource.example.path_part
  settings = {
    authorization = "MyUserPoolAuthorizer"
  }
}

resource "aws_api_gateway_deployment" "example" {
  depends_on  = [
    aws_api_gateway_integration.example,
    aws_api_gateway_method_response.example,
    aws_api_gateway_integration_response.example,
    aws_api_gateway_method_settings.example
  ]
  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = "dev"
}
