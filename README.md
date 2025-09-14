# Introduction:
This page serves as a documentation hub for understanding and using the Terraform infrastructure-as-code (IAC) configurations in this repository. Whether you're a newcomer or an experienced user, this guide will help you get started with deploying and managing infrastructure using Terraform.

**Author:** Ahsan Kazmi

Table of Contents:

1. [Getting Started](#getting-started)
2. [Project Structure](#project-structure)
3. [Modules](#modules)
4. [Variables](#variables)
5. [Configuration](#configuration)
6. [Usage](#usage)


# Getting Started:
Before you begin, make sure you have Terraform installed on your local machine. You can download it from [Terraform's official website](https://www.terraform.io/downloads.html). Additionally, clone this repository to your local environment.

# Project Structure:
The Terraform code in this repository follows a structured layout to promote maintainability and reusability. The main directories include:

- `main.tf` The main configuration file where resources are defined.  
- `variables.tf` Declare variables used in your configuration.  
- `outputs.tf` Declare outputs used in your configuration.  
- `modules/` Store reusable modules that encapsulate specific functionality.  
- `environments/` Organise configurations for different environments (e.g., development, production).  

# Modules:
We encourage modularisation to enhance code organisation and reusability. Currently, we are using public modules for the following resources in the cloud. 

- `VPC` Establishes Virtual Private Cloud (VPC) networks to isolate and manage resources.
- `EKS` Creates the relevant Elastic Kubernetes Service (EKS) resources. 
- `ECR` Create Elastic Container Repository (ECR) repository in AWS. 
- `IAM` Creates relevant IAM resources for Kubernetes and GitHub Actions. 


# Variables:
Customize your deployments using variables defined in variables.tf. Adjust these variables based on your requirements and environment.
terraform.tfvars: The values for the variables are defined centrally for each environment in terraform.tfvars file.

# Configuration:
Your Terraform configuration defines the desired state of your infrastructure. Review and modify main.tf to specify the resources you want to create, update, or delete.

# Usage:

## Terraform
To apply the Terraform configuration, follow these steps:

> Clone the repository.
```
cd $(pwd)/rak-ahsan-solution/terraform
```
> Replace the following names throughout the repository
<aws-account-id> with your account ID. 
<aws-region> with the region you want to deploy the app in. 
<aws-kms-key-id> with the KMS key to encrypt the EBS volume of the nodes.  

> Initialise the Terraform code
```
terraform init
```
> Plan the changes to apply to the infrastructure and review these changes.
```
terraform plan
```
> Apply the changes to the infrastructure.
```
terraform apply
```

## GitHub Actions
Add the following variables in the GitHub repository. 
<ASSUME_ROLE_ARN> with the deployed role in the module
<AWS_REGION> with the AWS region
<CLUSTER_NAME> with the EKS cluster name
<HELM_CHART> with the name of helm chart
<ECR_REPOSITORY> with the name of ECR repository