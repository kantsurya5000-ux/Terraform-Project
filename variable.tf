variable "cluster" {
  description = "Configuration for the one shared AKS cluster."
  type = object({
    name               = string
    resource_group_name = string
    location           = string
    dns_prefix         = string
    kubernetes_version = optional(string)
    node_count         = optional(number, 2)
    node_vm_size       = optional(string, "Standard_D2s_v5")
    vnet_cidr          = optional(string, "10.20.0.0/16")
    aks_subnet_cidr    = optional(string, "10.20.0.0/22")
    tags               = optional(map(string), {})
  })
}

variable "namespaces" {
  description = "Namespaces hosted in the shared AKS cluster."
  type        = set(string)
  default     = ["dev", "qa", "prod"]
}
