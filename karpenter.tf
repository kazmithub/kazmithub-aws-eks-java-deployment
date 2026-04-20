# Karpenter - Modern Alternative to Managed Node Groups
# Karpenter automatically provisions right-sized compute resources
# in response to unschedulable pods.

# module "karpenter" {
#   source  = "terraform-aws-modules/eks/aws//modules/karpenter"
#   version = "~> 20.0"
#
#   cluster_name = module.eks.cluster_name
#
#   irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
#   irsa_namespace_service_accounts = ["karpenter:karpenter"]
#
#   tags = var.tags
# }

# resource "kubectl_manifest" "karpenter_node_class" {
#   yaml_body = <<-YAML
#     apiVersion: karpenter.k8s.aws/v1beta1
#     kind: EC2NodeClass
#     metadata:
#       name: default
#     spec:
#       amiFamily: AL2
#       role: "${module.karpenter.role_name}"
#       subnetSelectorTerms:
#         - tags:
#             karpenter.sh/discovery: "${module.eks.cluster_name}"
#       securityGroupSelectorTerms:
#         - tags:
#             karpenter.sh/discovery: "${module.eks.cluster_name}"
#   YAML
# }

# resource "kubectl_manifest" "karpenter_node_pool" {
#   yaml_body = <<-YAML
#     apiVersion: karpenter.sh/v1beta1
#     kind: NodePool
#     metadata:
#       name: default
#     spec:
#       template:
#         spec:
#           nodeClassRef:
#             name: default
#           requirements:
#             - key: "karpenter.k8s.aws/instance-category"
#               operator: In
#               values: ["c", "m", "r"]
#             - key: "karpenter.k8s.aws/instance-generation"
#               operator: Gt
#               values: ["5"]
#             - key: "kubernetes.io/arch"
#               operator: In
#               values: ["amd64", "arm64"]
#             - key: "karpenter.sh/capacity-type"
#               operator: In
#               values: ["spot", "on-demand"]
#       limits:
#         cpu: 100
#         memory: 200Gi
#       disruption:
#         consolidationPolicy: WhenUnderutilized
#   YAML
# }
