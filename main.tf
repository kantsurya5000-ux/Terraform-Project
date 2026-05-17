resource "azurerm_resource_group" "rg" {
  for_each = var.rg_name 
  name     = each.key
  location = each.value
}

resource "azurerm_storage_account" "st" {
  for_each                 = var.st_name 
  depends_on              = [azurerm_resource_group.rg] 
  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}

resource "azurerm_storage_container" "container" {
  for_each              = var.container_name
  depends_on           = [azurerm_storage_account.st]  
  name                  = each.value.name
  storage_account_id    = azurerm_storage_account.st[each.value.storage_account_id].id
  container_access_type = "private"
}
