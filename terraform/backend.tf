
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-ticktra-storage-tfstate"
    storage_account_name = "ticktrastorage"
    container_name       = "tfstate"
    key                  = "ticktra-dev.tfstate"
  }
}
