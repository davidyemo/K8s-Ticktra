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

variable "container_registry_name" {
  description = "Name of the container registry"
  type        = string
  default     = "ticktraregistry1"
}