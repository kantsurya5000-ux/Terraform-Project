terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.73.0"
    }
  }
  backend "azurerm" {
    resource_group_name   = "SURYA_RG"
    storage_account_name  = "suryast"
    container_name        = "suryacontainer123"
    key                   = "suryaterraform.tfstate"
  } 
}

provider "azurerm" {
  features {}
}