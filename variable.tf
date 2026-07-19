variable "subscription_id" {
  description = "The subscription ID for the Azure account."
  type        = string
}

variable "tenant_id" {
  description = "The tenant ID for the Azure account."
  type        = string
}





variable "key" {
  description = "The key for the remote state file in the Azure Storage Account."
  type        = string

}



variable "cluster" {
  description = "Configuration for the one shared AKS cluster."
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    dns_prefix          = string
    kubernetes_version  = optional(string)
    sku_tier            = optional(string, "Free")
    node_count          = optional(number, 2)
    node_vm_size        = optional(string, "Standard_D2s_v5")
    vnet_cidr           = optional(string, "10.20.0.0/16")
    aks_subnet_cidr     = optional(string, "10.20.0.0/22")
    tags                = optional(map(string), {})
  })
}

variable "namespaces" {
  description = "Namespaces hosted in the shared AKS cluster."
  type        = set(string)
  default     = ["dev", "qa", "prod"]

  validation {
    condition     = alltrue([for name in var.namespaces : can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", name))])
    error_message = "Namespace names must be valid lowercase Kubernetes DNS labels."
  }
}
