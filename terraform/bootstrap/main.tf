resource "azurerm_resource_group" "Resource_Group_Storage" {
  name     = "rg-ticktra-storage-tfstate"
  location = "uksouth"
}

resource "azurerm_storage_account" "Storage_Account" {
  name                     = "ticktrastorage"
  resource_group_name      = azurerm_resource_group.Resource_Group_Storage.name
  location                 = azurerm_resource_group.Resource_Group_Storage.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.Storage_Account.id
  container_access_type = "private"
}