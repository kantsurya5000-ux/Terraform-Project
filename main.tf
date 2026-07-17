resource "azurerm_resource_group" "this" {
  name     = var.cluster.resource_group_name
  location = var.cluster.location
  tags     = var.cluster.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.cluster.name}-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.cluster.vnet_cidr]
  tags                = var.cluster.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "aks"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.cluster.aks_subnet_cidr]
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.cluster.dns_prefix
  kubernetes_version  = var.cluster.kubernetes_version
  sku_tier            = var.cluster.sku_tier

  default_node_pool {
    name           = "system"
    vm_size        = var.cluster.node_vm_size
    node_count     = var.cluster.node_count
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  tags = var.cluster.tags
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.this.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.this.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}

resource "kubernetes_namespace_v1" "environment" {
  for_each = toset(var.namespaces)

  metadata {
    name = each.value
    labels = {
      environment = each.value
      managed-by  = "terraform"
    }
  }

  depends_on = [azurerm_kubernetes_cluster.this]
}
