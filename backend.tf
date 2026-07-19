terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36"
    }
  }

  # Backend values are supplied securely by Azure DevOps at `terraform init`.
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}
