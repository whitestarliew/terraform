provider "aws" {
  region = var.aws_region # Change this to your desired AWS region
}
resource "aws_cognito_user_pool" "example_user_pool" {
  name = "test-user-pool"
  # Add more configuration options as needed
}
resource "aws_cognito_identity_pool" "example_identity_pool" {
  identity_pool_name = "test-identity-pool"
  allow_unauthenticated_identities = false

locals {
  valid_client_id = replace(aws_cognito_user_pool.example_user_pool.id, "[^a-zA-Z0-9]", "_")
}

  # Link to the user pool created above
  cognito_identity_providers {
    client_id               = local.valid_client_id
    provider_name           = aws_cognito_user_pool.example_user_pool.endpoint
    server_side_token_check = false
  }

  # Add more configuration options as needed
}

output "user_pool_id" {
  value = aws_cognito_user_pool.example_user_pool.id
}

output "identity_pool_id" {
  value = aws_cognito_identity_pool.example_identity_pool.id
}
