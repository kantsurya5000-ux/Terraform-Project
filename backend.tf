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
}

provider "azurerm" {
  features {}
}

# A remote state backend can be supplied at init time, for example:
# terraform init -backend-config="resource_group_name=..." ...
# Keeping it out of source avoids hard-coded storage-account details.
