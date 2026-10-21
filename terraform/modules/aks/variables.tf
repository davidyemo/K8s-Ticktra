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