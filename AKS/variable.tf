

variable "cluster" {
  description = "AKS Cluster Configuration"

  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    dns_prefix          = string

    kubernetes_version = optional(string, "1.32")
    sku_tier           = optional(string, "Standard")

    node_count   = optional(number, 2)
    node_vm_size = optional(string, "Standard_D2s_v5")

    vnet_cidr       = string
    aks_subnet_cidr = string

    tags = optional(map(string), {})
  }))
}

variable "namespaces" {
  type    = set(string)
  default = ["dev", "qa", "prod"]
}