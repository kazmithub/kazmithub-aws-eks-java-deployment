# AWS EKS Java Deployment

Production-grade Kubernetes deployment on AWS EKS with Terraform, Helm, and GitHub Actions CI/CD.

## Architecture

```
GitHub Actions CI/CD
        |
        v
   Docker Build --> ECR Registry
        |
        v
   Terraform Apply
        |
        +---> VPC (Public + Private Subnets, NAT Gateway)
        +---> EKS Cluster (Managed Node Groups / Karpenter)
        +---> IAM Roles (OIDC-based IRSA)
        +---> Helm Release --> Kubernetes Deployment
                                    |
                                    +---> HPA (Auto-scaling)
                                    +---> Network Policies
                                    +---> Service + Ingress
```

## Key Features

- **Infrastructure as Code** - Full AWS infrastructure managed with Terraform modules
- **EKS with OIDC** - Secure IAM role binding using IRSA (IAM Roles for Service Accounts)
- **Helm-based Deployments** - Application packaged and deployed via Helm charts
- **CI/CD Pipeline** - GitHub Actions for automated build, test, and deploy
- **Auto-scaling** - Horizontal Pod Autoscaler (HPA) for application pods
- **Network Security** - Kubernetes Network Policies for pod-to-pod communication
- **Karpenter Ready** - Alternative node provisioning for cost optimization
- **Monitoring** - Prometheus + Grafana stack configuration included

## Prerequisites

- AWS CLI v2 configured with appropriate credentials
- Terraform >= 1.5.0
- kubectl >= 1.28
- Helm >= 3.12
- Docker for building application images

## Project Structure

```
.
├── main.tf                  # EKS cluster, VPC, IAM configuration
├── variables.tf             # Input variables
├── outputs.tf               # Output values
├── providers.tf             # Provider configuration
├── karpenter.tf             # Karpenter node provisioner (optional)
├── monitoring.tf            # Prometheus + Grafana stack (optional)
├── backend.tf               # S3 remote state configuration
├── helm/                    # Helm chart for Java application
├── k8s/                     # Kubernetes manifests (HPA, NetworkPolicy)
├── .github/workflows/       # CI/CD pipeline
└── app/                     # Java application source
```

## Deployment

```bash
# 1. Initialize Terraform
terraform init

# 2. Review the execution plan
terraform plan

# 3. Apply infrastructure
terraform apply

# 4. Configure kubectl
aws eks update-kubeconfig --name <cluster-name> --region <region>

# 5. Verify deployment
kubectl get pods -A
kubectl get svc
```

## Cleanup

```bash
terraform destroy
```

## Modules Used

| Module | Version | Purpose |
|--------|---------|---------|
| terraform-aws-modules/vpc/aws | 5.7.1 | VPC with public/private subnets |
| terraform-aws-modules/eks/aws | ~> 20.0 | EKS cluster and managed node groups |

## License

MIT
