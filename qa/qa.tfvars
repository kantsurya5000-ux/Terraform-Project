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

namespaces      = ["dev", "qa", "prod"]
subscription_id = "8b004955-1932-487e-a46b-1d456748ea2b"
tenant_id       = "8f81e8bf-35c9-4c3c-b0c8-6debfb5ad60e"
key             = "qa.tfstate"
