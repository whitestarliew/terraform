provider "aws" {
  region = var.aws_regions
}

resource "aws_cognito_user_pool" "test_user_pool" {
  name = "user1_pool"

  schema {
    name                     = "foo"
    attribute_data_type      = "Boolean"
    mutable                  = false
    required                 = false
    developer_only_attribute = false
    string_attribute_constraints {}
  }
}

resource "aws_cognito_user" "example" {
  user_pool_id = aws_cognito_user_pool.test_user_pool
  username     = "john_doe"
}

output "user_pool_id" {
  value = aws_cognito_user_pool.test_user_pool.id
}


