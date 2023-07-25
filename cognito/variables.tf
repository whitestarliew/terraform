variable "aws_regions" {
  description = "The desired AWS region."
  default     = "us-east-1"  # Replace this with your preferred default region
}

# variable "valid_client_id" {
#   description = "Computed valid client_id"
#   default     = replace(aws_cognito_user_pool.example_user_pool.id, "[^a-zA-Z0-9]", "_")
# }
