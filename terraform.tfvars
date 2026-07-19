cluster = {
  name                = "aks-shared-devqa-prod"
  resource_group_name = "rg-aks-shared"
  location            = "Central India"
  dns_prefix          = "aksshared"
  tags = {
    managed_by = "terraform"
    purpose    = "shared-environments"
  }
}

namespaces = ["dev", "qa", "prod"]
