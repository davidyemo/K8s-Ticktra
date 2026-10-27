variable "resource_group_name" {
  description = "Name of the resource group that holds the Terraform state"
  type        = string
  default     = "rg-ticktra-storage-tfstate"
}

variable "location" {
  description = "Azure region for the state storage"
  type        = string
  default     = "uksouth"
}

variable "storage_account_name" {
  description = "Name of the storage account for Terraform state (must be globally unique, lowercase letters and numbers only)"
  type        = string
  default     = "ticktrastorage"
}

variable "account_tier" {
  description = "Performance tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "How the storage account data is replicated"
  type        = string
  default     = "GRS"
}

variable "container_name" {
  description = "Name of the blob container that stores the state file"
  type        = string
  default     = "tfstate"
}