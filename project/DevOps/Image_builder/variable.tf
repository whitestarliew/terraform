variable "region" {
  default = "us-east-1"
}

variable "pipeline_name" {
  default = "testing-123"
}

variable "pipeline_description" {
  default = "hello testing for linux"
}

variable "image_recipe_name" {
  default = "linux-2"
}

variable "image_recipe_version" {
  default = "1.0.0"
}

variable "base_image_name" {
  default = "amazon-linux2-arm64-base"
}

variable "enhanced_metadata_collection" {
  default = true
}

variable "storage_size" {
  default = 20
}
