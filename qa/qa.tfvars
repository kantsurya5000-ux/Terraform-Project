# Same shared-cluster configuration as dev/dev.tfvars. Use only one tfvars file per deployment.
cluster = {
  name                = "aks-shared-devqa-prod"
  resource_group_name = "rg-aks-shared"
  location            = "East US"
  dns_prefix          = "aksshared"
  tags = {
    managed_by = "terraform"
    purpose    = "shared-environments"
  }
}

namespaces = ["dev", "qa", "prod"]
