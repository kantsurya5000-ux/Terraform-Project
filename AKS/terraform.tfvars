cluster = {

  dev = {
    name                = "aks-dev"
    resource_group_name = "rg-aks-dev"
    location            = "Central India"
    dns_prefix          = "aks-dev"

    kubernetes_version = "1.32"
    node_count         = 2
    node_vm_size       = "Standard_D2s_v5"

    vnet_cidr       = "10.10.0.0/16"
    aks_subnet_cidr = "10.10.1.0/24"

    tags = {
      Environment = "Dev"
    }
  }

  qa = {
    name                = "aks-qa"
    resource_group_name = "rg-aks-qa"
    location            = "Central India"
    dns_prefix          = "aks-qa"

    kubernetes_version = "1.32"
    node_count         = 2
    node_vm_size       = "Standard_D2s_v5"

    vnet_cidr       = "10.20.0.0/16"
    aks_subnet_cidr = "10.20.1.0/24"

    tags = {
      Environment = "QA"
    }
  }

  prod = {
    name                = "aks-prod"
    resource_group_name = "rg-aks-prod"
    location            = "Central India"
    dns_prefix          = "aks-prod"

    kubernetes_version = "1.32"
    node_count         = 3
    node_vm_size       = "Standard_D4s_v5"

    vnet_cidr       = "10.30.0.0/16"
    aks_subnet_cidr = "10.30.1.0/24"

    tags = {
      Environment = "Prod"
    }
  }
}