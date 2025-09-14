### VPC module variables

variable "NAME" {
  description = "The name of the VPC"
  default     = "my-vpc"
}

variable "CIDR" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "AZS" {
  description = "A list of availability zones"
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "PRIVATE_SUBNETS" {
  description = "A list of private subnet CIDRs"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "PUBLIC_SUBNETS" {
  description = "A list of public subnet CIDRs"
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "ENABLE_NAT_GATEWAY" {
  description = "Boolean flag to enable/disable NAT Gateway"
  default     = true
}

variable "TAGS" {
  description = "A map of tags to apply to the VPC and subnets"
  default = {
    Environment = "dev"
    Project     = "my-project"
  }
}

variable "PUBLIC_SUBNET_TAGS" {
  description = "A map of tags to apply to the public subnets"
}

variable "PRIVATE_SUBNET_TAGS" {
  description = "A map of tags to apply to the private subnets"
}

### EKS module variables

variable "CLUSTER_VERSION" {
  description = "The Kubernetes version for the EKS cluster"
  default     = "1.21"
}

variable "CLUSTER_ENDPOINT_PUBLIC_ACCESS" {
  description = "Boolean flag to enable/disable public access to the EKS cluster endpoint"
  default     = true
}

variable "CLUSTER_ADDONS" {
  description = "A list of cluster addons to enable"
}

variable "EKS_MANAGED_NODE_GROUPS" {
  description = "A map defining EKS managed node groups"
}

variable "ENABLE_CLUSTER_CREATOR_ADMIN_PERMISSIONS" {
  description = "Boolean flag to enable/disable admin permissions for the cluster creator"
  default     = true
}

### OIDC module variables

variable "GITHUB_URL" {
  description = "The URL of the GitHub repository for OIDC"
  default     = "https://github.com/my-org/my-repo"
}
