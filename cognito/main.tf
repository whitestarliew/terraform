provider "aws" {
  region = var.aws_regions
}

resource "aws_cognito_user_pool" "pool" {
  name = "mypool"
}

output "user_pool_id" {
  value = aws_cognito_user_pool.example_user_pool.id
}


