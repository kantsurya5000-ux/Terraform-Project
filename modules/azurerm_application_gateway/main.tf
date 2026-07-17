variable "application_gateways" {
  type = map(object({
    location            = string
    resource_group_name = string
    subnet_id           = string
    sku_name            = string
    sku_tier            = string
    capacity            = number
    frontend_port       = number
    private_ip_address  = string
  }))
}

resource "azurerm_public_ip" "agw_pip" {
  for_each = var.application_gateways

  name                = "${each.key}-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "agw" {
  for_each = var.application_gateways

  name                = each.key
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.capacity
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = each.value.subnet_id
  }

  frontend_port {
    name = "http-port"
    port = each.value.frontend_port
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.agw_pip[each.key].id
  }

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "http-setting"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-setting"
    priority                   = 100
  }
}