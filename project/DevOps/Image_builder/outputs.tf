output "pipeline_arn" {
  value = aws_imagebuilder_pipeline.example.arn
}

output "image_recipe_arn" {
  value = aws_imagebuilder_image_recipe.example.arn
}
