# ---------- General ----------
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-ticktra-prod"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "uksouth"
}

# ---------- Identity ----------
variable "admin_user_upn" {
  description = "Entra login of the AKS admin"
  type        = string
}

# ---------- Container registry ----------
variable "container_registry_name" {
  description = "Name of the container registry"
  type        = string
  default     = "ticktraregistry1"
}

variable "acr_sku" {
  description = "Pricing tier of the container registry (Basic, Standard or Premium)"
  type        = string
  default     = "Premium"
}

# ---------- Networking ----------
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "ticktra-vnet"
}

variable "vnet_address_space" {
  description = "Address range for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
  default     = "aks-subnet"
}

variable "aks_subnet_prefixes" {
  description = "Address range for the AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "public_subnet_name" {
  description = "Name of the public subnet"
  type        = string
  default     = "public-subnet"
}

variable "public_subnet_prefixes" {
  description = "Address range for the public subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

# ---------- AKS ----------
variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "ticktra-aks-cluster"
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS API server address"
  type        = string
  default     = "ticktraaks"
}

variable "node_pool_name" {
  description = "Name of the default node pool"
  type        = string
  default     = "default"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for the AKS nodes"
  type        = string
  default     = "Standard_D2als_v6"
}

variable "service_cidr" {
  description = "IP range for Kubernetes services"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address of the cluster DNS service"
  type        = string
  default     = "10.1.0.10"
}