


variable "aks" {
  description = "Boolean to determine if AKS cluster should be created"
  type        = bool
  default     = true
}
variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}
variable "location" {
  description = "The location of the AKS cluster"
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}
variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
}
variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
}
variable "vm_size" {
  description = "The size of the VMs in the default node pool"
  type        = string
}
variable "tags" {
  description = "A map of tags to apply to the AKS cluster"
  type        = map(string)
}
resource "azurerm_kubernetes_cluster" "aks" {
  for_each            = var.aks ? { "aks" = 1 } : {}
  name                = each.value.cluster_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = each.value.node_count
    vm_size    = each.value.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = each.value.tags
}