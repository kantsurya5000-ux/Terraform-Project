output "cluster_name" {
  value       = azurerm_kubernetes_cluster.this.name
  description = "The shared AKS cluster name."
}

output "cluster_resource_group" {
  value       = azurerm_resource_group.this.name
  description = "The resource group containing the shared cluster."
}

output "namespace_names" {
  value       = sort([for namespace in kubernetes_namespace_v1.environment : namespace.metadata[0].name])
  description = "Namespaces created in the shared cluster."
}
