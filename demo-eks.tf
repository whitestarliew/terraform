locals {
  cluster_name = "demo-cluster"
  tags = {
    env     = "staging"
    project = "demo-project"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = local.cluster_name
  cluster_version = "1.21"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] 

  tags = local.tags

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 200
  }

  node_groups = {
    for idx in range(length(module.vpc.private_subnets)) :
    "stg-eks-nodes-${module.vpc.azs[idx]}" => {
      name    = "stg-eks-nodes-${module.vpc.azs[idx]}"
      subnets = [module.vpc.private_subnets[idx]]

      desired_capacity = 1
      max_capacity     = 6
      min_capacity     = 1

      instance_types = ["t2.mirco"]

      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }
  }

  manage_aws_auth = false
}

# oidc provider: keycloak
resource "aws_eks_identity_provider_config" "keycloak" {
  cluster_name = local.cluster_name
  oidc {
    client_id                     = "washhub-staging-eks"
    groups_claim                  = "groups"
    groups_prefix                 = "gid:"
    identity_provider_config_name = "Keycloak"
    issuer_url                    = "abc.com/abddocuments"
    username_claim                = "email"
  }
  tags = local.tags
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}
