resource "azurerm_subnet" "subnet1" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = each.value.azurerm_resource_group.rg1[each.key].name
  virtual_network_name = each.value.azurerm_virtual_network.vnet1[each.key].name
  address_prefixes     = each.value.address_prefixes
}