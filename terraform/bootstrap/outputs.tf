output "resource_group_name" {
  value = azurerm_resource_group.Resource_Group_Storage.name
}

output "storage_account_name" {
  value = azurerm_storage_account.Storage_Account.name
}

output "container_name" {
  value = azurerm_storage_container.tfstate.name
}