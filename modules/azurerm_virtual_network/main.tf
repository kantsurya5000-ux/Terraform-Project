resource "azurerm_virtual_network" "vnet1" {
  for_each            = var.vnets
  name                = each.value.name
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = each.value.azurerm_resource_group.rg1[each.key].name
}