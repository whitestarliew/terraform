
data "aws_iam_role" "eks_role" {
  name = "AWSServiceRoleForAmazonEKS"
}

module "VPC_ID" {
  source = "VPN_module"  

}
resource "aws_eks_cluster" "testing_eks" {
  name = "sample-eks-cluster"
  role_arn = data.aws_iam_role.eks_role
  vpc_config {
    subnet_ids = module.VPC_ID.public_subnet_id_output    
  }
  
}