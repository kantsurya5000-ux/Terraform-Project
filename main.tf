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

resource "azurerm_network_security_group" "aks" {
  name                = "${var.cluster.name}-aks-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.cluster.tags
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}

resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.cluster.name}-logs"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.cluster.tags
}

resource "azurerm_kubernetes_cluster" "this" {
  #checkov:skip=CKV_AZURE_6: A private cluster has no public API endpoint; authorized IP ranges are inapplicable.
  #checkov:skip=CKV_AZURE_117: Platform-managed disk encryption is intentionally used; supply a customer-managed disk_encryption_set_id only when required by policy.
  name                               = var.cluster.name
  location                           = azurerm_resource_group.this.location
  resource_group_name                = azurerm_resource_group.this.name
  dns_prefix                         = var.cluster.dns_prefix
  kubernetes_version                 = var.cluster.kubernetes_version
  sku_tier                           = "Standard"
  private_cluster_enabled            = true
  private_cluster_public_fqdn_enabled = false
  local_account_disabled             = true
  azure_policy_enabled               = true
  automatic_upgrade_channel          = "patch"

  default_node_pool {
    name                         = "system"
    vm_size                      = var.cluster.node_vm_size
    node_count                   = var.cluster.node_count
    vnet_subnet_id               = azurerm_subnet.aks.id
    max_pods                     = 50
    os_disk_type                 = "Ephemeral"
    os_disk_size_gb              = 64
    only_critical_addons_enabled = true
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = var.cluster.tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "terraform_cluster_admin" {
  scope                = azurerm_kubernetes_cluster.this.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.current.object_id
}

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.this.kube_config[0].host
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login", "azurecli",
      "--server-id", "6dae42f8-4368-4678-94ff-3960e28e3630"
    ]
  }
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

  depends_on = [azurerm_role_assignment.terraform_cluster_admin]
}
