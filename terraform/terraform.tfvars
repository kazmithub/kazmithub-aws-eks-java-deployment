### VPC module variables
NAME               = "rak"
CIDR               = "10.0.0.0/16"
AZS                = ["us-east-1a", "us-east-1b"]
PRIVATE_SUBNETS    = ["10.0.1.0/24", "10.0.2.0/24"]
PUBLIC_SUBNETS     = ["10.0.11.0/24", "10.0.12.0/24"]
ENABLE_NAT_GATEWAY = true

TAGS = {
  Terraform   = "true"
  Environment = "prod"
}
PUBLIC_SUBNET_TAGS = {
  "kubernetes.io/role/elb"            = "1",
  "kubernetes.io/cluster/rak-cluster" = "owned"
}
PRIVATE_SUBNET_TAGS = {
  "kubernetes.io/cluster/rak-cluster" = "owned"
}

### EKS module variables
CLUSTER_VERSION                          = "1.29"
CLUSTER_ENDPOINT_PUBLIC_ACCESS           = true
ENABLE_CLUSTER_CREATOR_ADMIN_PERMISSIONS = false

CLUSTER_ADDONS = {
  coredns = {
    most_recent = true
  }
  kube-proxy = {
    most_recent = true
  }
  vpc-cni = {
    most_recent = true
  }
}

EKS_MANAGED_NODE_GROUPS = {
  eks-node = {
    min_size       = 1
    max_size       = 1
    desired_size   = 1
    instance_types = ["t3.large"]
    ebs_encrypted  = true
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 128
          volume_type           = "gp3"
          iops                  = 3000
          throughput            = 150
          encrypted             = true
          kms_key_id            = "arn:aws:kms:us-east-1:<aws-account-id>:key/<aws-kms-key-id>"
          delete_on_termination = true
        }
      }
    }
  }
}


### OIDC module variables
GITHUB_URL = "https://token.actions.githubusercontent.com"
