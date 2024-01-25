
data "aws_iam_role" "eks_role" {
  name = "AWSServiceRoleForAmazonEKS"
}

module "VPC_ID" {
  source = "..//VPC_module"  

}

#At least 2 AZ for H.A
resource "aws_eks_cluster" "testing_eks" {
  name = "sample-eks-cluster"
  role_arn = data.aws_iam_role.eks_role.arn
  vpc_config {
    subnet_ids = [module.VPC_ID.public_subnet_id_output, module.VPC_ID.public_subnet_id_2_output]
  }
}