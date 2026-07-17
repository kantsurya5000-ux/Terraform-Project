resource "azurerm_public_ip" "nat_pip" {
  for_each = var.nat_gateways

  name                = "${each.key}-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat" {
  for_each = var.nat_gateways

  name                    = each.key
  location                = each.value.location
  resource_group_name     = each.value.resource_group_name
  sku_name                = each.value.sku_name
  idle_timeout_in_minutes = each.value.idle_timeout
}

resource "azurerm_nat_gateway_public_ip_association" "nat_pip_assoc" {
  for_each = var.nat_gateways

  nat_gateway_id       = azurerm_nat_gateway.nat[each.key].id
  public_ip_address_id = azurerm_public_ip.nat_pip[each.key].id
}

variable "nat_gateways" {
  type = map(object({
    location            = string
    resource_group_name = string
    sku_name            = string
    idle_timeout        = number
  }))
}