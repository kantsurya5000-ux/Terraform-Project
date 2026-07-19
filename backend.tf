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
  backend "azurerm" {
    resource_group_name  = "rgtest"
    storage_account_name = "testsuryast"
    container_name       = "suryacontainer"
    key                  = var.key
  }

}

  provider "azurerm" {
    features {}
    # ye add karo:
    use_cli                         = true
    subscription_id                 = var.subscription_id
    tenant_id                       = var.tenant_id
    resource_provider_registrations = "none"
  }





# A remote state backend can be supplied at init time, for example:
# terraform init -backend-config="resource_group_name=..." ...
# Keeping it out of source avoids hard-coded storage-account details.
