output "resource_group_name" {
  value = data.azurerm_resource_group.Resource_Group
}

output "storage_account_name" {
  value = azurerm_storage_account.tfstate.name
}

output "container_name" {
  value = azurerm_storage_container.tfstate.name
}