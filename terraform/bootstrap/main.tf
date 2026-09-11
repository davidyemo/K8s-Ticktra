data "azurerm_resource_group" "Resource_Group" {
  name = "rg-ticktra-prod"   # exact name as it appears in Azure
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "ticktratfstate123"   
  resource_group_name      = data.azurerm_resource_group.Resource_Group.name
  location                 = data.azurerm_resource_group.Resource_Group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  container_access_type = "private"
  storage_account_id     = azurerm_storage_account.tfstate.id
}