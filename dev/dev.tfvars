# This is a shared-cluster configuration. Apply it once; it creates dev, qa, and prod namespaces.
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


