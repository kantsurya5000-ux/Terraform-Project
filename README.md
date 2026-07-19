# Shared AKS cluster

This configuration creates one Azure Kubernetes Service (AKS) cluster and three namespaces: `dev`, `qa`, and `prod`. The namespaces are logical isolation boundaries inside the same cluster; they are not separate AKS clusters.

The cluster is private, uses Azure RBAC, Azure Policy, Azure CNI network policy, Azure Monitor, secret rotation, ephemeral OS disks, and a Standard SKU. `kubelogin` is required because local AKS admin accounts are disabled.

## Deploy

Authenticate to Azure, then run the following from this directory:

```powershell
terraform init
terraform plan -var-file="dev/dev.tfvars"
terraform apply -var-file="dev/dev.tfvars"
```

Because the AKS API endpoint is private, run Terraform from a self-hosted Azure DevOps agent or another machine that has private network access to the AKS VNet. The authenticated Azure identity must be allowed to create role assignments.

The `dev`, `qa`, and `prod` tfvars files intentionally have the same shared-cluster configuration. Use **one** of them for a deployment, not all three.

## Important operational note

Namespaces alone do not enforce complete isolation. Before deploying workloads, add Kubernetes RBAC roles, resource quotas, limit ranges, and network policies for each namespace. Use separate clusters for environments that require strong security or availability isolation.

## Checkov scope

Scan the deployable shared-cluster configuration with `checkov -d . --skip-path modules`. The `modules/` directory contains legacy, unreferenced infrastructure modules and is not part of this AKS deployment. Two exceptions are documented inline: API authorized IP ranges do not apply to a private AKS API, and platform-managed disk encryption is used unless your organization provides a customer-managed Disk Encryption Set.

## Remote state

The configuration uses Terraform's default local state until a backend is supplied. For team use, configure an Azure Storage backend securely at `terraform init` time rather than committing backend account details to source control.
