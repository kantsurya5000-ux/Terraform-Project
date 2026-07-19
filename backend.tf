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

  backend "azurerm" {}
}
  backend "azurerm" {
    resource_group_name  = "rgtest"
    storage_account_name = "testsuryast"
    container_name       = "suryacontainer"
    key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
  # ye add karo:
  use_cli                         = true
  subscription_id                 = "8b004955-1932-487e-a46b-1d456748ea2b"
  tenant_id                       = "8f81e8bf-35c9-4c3c-b0c8-6debfb5ad60e"
  resource_provider_registrations = "none"
}





# Backend values are provided securely by the Azure DevOps pipeline at init time.
