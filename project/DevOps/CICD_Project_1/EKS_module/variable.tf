variable "vpc_id" {
    description = "VPC for deployment"
    type = string
    default = ""
}

variable "cluster_name" {
    default = "eks-testing"
    type = string
}