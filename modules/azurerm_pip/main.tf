resource "azurerm_public_ip" "pip1" {
  for_each            = var.pips
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.azurerm_resource_group.rg1[each.key].name
  allocation_method   = each.value.allocation_method

}

variable "pips" {

}