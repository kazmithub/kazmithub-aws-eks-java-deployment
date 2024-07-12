data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.1"
  name    = "${var.NAME}-vpc"

  cidr = var.CIDR

  azs             = var.AZS
  private_subnets = var.PRIVATE_SUBNETS
  public_subnets  = var.PUBLIC_SUBNETS

  enable_nat_gateway  = var.ENABLE_NAT_GATEWAY
  public_subnet_tags  = var.PUBLIC_SUBNET_TAGS
  private_subnet_tags = var.PRIVATE_SUBNET_TAGS
  tags                = var.TAGS
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                   = "${var.NAME}-cluster"
  cluster_version                = var.CLUSTER_VERSION
  cluster_endpoint_public_access = var.CLUSTER_ENDPOINT_PUBLIC_ACCESS
  cluster_addons                 = var.CLUSTER_ADDONS

  vpc_id                                   = module.vpc.vpc_id
  subnet_ids                               = module.vpc.private_subnets
  control_plane_subnet_ids                 = module.vpc.public_subnets
  eks_managed_node_groups                  = var.EKS_MANAGED_NODE_GROUPS
  enable_cluster_creator_admin_permissions = var.ENABLE_CLUSTER_CREATOR_ADMIN_PERMISSIONS
  access_entries = {
    eks_role = {
      kubernetes_groups = []
      principal_arn     = module.iam_assumable_role_with_oidc_for_eks.arn
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
    terraform_role = {
      kubernetes_groups = []
      principal_arn     = module.iam_assumable_role_with_oidc_for_terraform.arn
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    },
    user_role = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.id}:user/task"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }
  }

  tags = var.TAGS
}

module "ecr" {
  source                          = "terraform-aws-modules/ecr/aws"
  repository_name                 = "${var.NAME}-repo"
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus   = "any",
          countType   = "imageCountMoreThan",
          countNumber = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  tags = var.TAGS
}

module "iam_github_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  url    = var.GITHUB_URL
  tags   = var.TAGS
}

module "iam_assumable_role_with_oidc_for_eks" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  name         = "${var.NAME}-role-with-oidc-for-eks"
  audience     = "sts.amazonaws.com"
  provider_url = module.iam_github_oidc_provider.url
  subjects     = ["*/assignment:*"]
  policies     = { "eks_cni" = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "ecr_access" = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "eks_custom_policy" = "${module.eks_iam_policy_for_eks.arn}" }
  tags         = var.TAGS
}

module "iam_assumable_role_with_oidc_for_terraform" {
  source       = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"
  name         = "${var.NAME}-role-with-oidc-for-terraform"
  audience     = "sts.amazonaws.com"
  provider_url = module.iam_github_oidc_provider.url
  subjects     = ["*/assignment:*"]
  policies     = { "eks_cni" = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "ecr_access" = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "eks_custom_policy" = "${module.eks_iam_policy_for_eks.arn}", "adminaccess" = "arn:aws:iam::aws:policy/AdministratorAccess" }
  tags         = var.TAGS
}

module "eks_iam_policy_for_eks" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "${var.NAME}-eks-policy"
  path        = "/"
  description = "IAM policy for eks cluster"

  policy = <<EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "eks:*"
              ],
              "Resource": "${module.eks.cluster_arn}"
          }
      ]
  }
  EOF
}
