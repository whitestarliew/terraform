resource "aws_codecommit_repository" "test" {
  repository_name = "Regov-Repository"
  description     = var.description
}