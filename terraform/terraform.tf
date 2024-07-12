terraform {
  backend "s3" {
    bucket         = "terraform-backend-<aws-account-id>"
    dynamodb_table = "Locking"
    region         = "<aws-region>"
    key            = "rakbank/terraform.tfstate"
  }
}
