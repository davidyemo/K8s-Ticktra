resource "azurerm_resource_group" "Resource_Group_Storage" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "Storage_Account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.Resource_Group_Storage.name
  location                 = azurerm_resource_group.Resource_Group_Storage.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.Storage_Account.id
  container_access_type = "private"
}