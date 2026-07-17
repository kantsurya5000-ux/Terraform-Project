
variable "acr" {
  description = "A map of ACR configuration."
  type = map(object({
    acr_name            = string
    location            = string
    resource_group_name = string
    sku                 = string
    admin_enabled       = bool
    tags                = map(string)
  }))
  default = {}
}



resource "azurerm_azure_container_registry" "acr" {
  for_each            = var.acr
  name                = each.value.acr_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  admin_enabled       = each.value.admin_enabled

  tags = each.value.tags
}