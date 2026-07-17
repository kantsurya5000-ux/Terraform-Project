resource "azurerm_firewall" "fw" {

  for_each = var.firewalls

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  sku {

    name = each.value.sku_name
    tier = each.value.sku_tier

  }

  ip_configuration {

    name = "fw-ip-config"

    subnet_id            = each.value.subnet_id
    public_ip_address_id = each.value.public_ip_address_id

  }

  tags = each.value.tags
}