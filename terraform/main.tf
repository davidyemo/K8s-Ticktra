resource "azurerm_resource_group" "Resource_Group" {
  name     = var.resource_group_name
  location = var.location
}

module "acr" {
  source = "./modules/acr"
  location = var.location
  resource_group_name = azurerm_resource_group.Resource_Group.name
  container_registry_name = var.container_registry_name
  
}