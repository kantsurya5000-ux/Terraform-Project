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
  # ye add karo:
  use_cli         = true
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  resource_provider_registrations = "none"
}

variable "subscription_id" {
  description = "The subscription ID for the Azure account."
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure account."
  type        = string
}


# A remote state backend can be supplied at init time, for example:
# terraform init -backend-config="resource_group_name=..." ...
# Keeping it out of source avoids hard-coded storage-account details.
