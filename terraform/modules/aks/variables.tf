variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "uksouth"
}

variable "subnet_id" {
  description = "ID of the subnet for the AKS cluster"
  type        = string
}

variable "admin_group_object_id" {
  description = "Object ID of the Azure AD group to be granted admin access to the AKS cluster"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS API server address"
  type        = string
}

variable "node_pool_name" {
  description = "Name of the default node pool"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
}

variable "vm_size" {
  description = "VM size for the nodes"
  type        = string
}

variable "service_cidr" {
  description = "IP range for Kubernetes services"
  type        = string
}

variable "dns_service_ip" {
  description = "IP address of the cluster DNS service (must be inside service_cidr)"
  type        = string
}