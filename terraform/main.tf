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

module "networking" {
  source = "./modules/networking"
  location = var.location
  resource_group_name = azurerm_resource_group.Resource_Group.name
}

module "aks" {
  source = "./modules/aks"
  location = var.location
  resource_group_name = azurerm_resource_group.Resource_Group.name
  subnet_id = module.networking.subnet_id
}

   resource "azurerm_role_assignment" "aks_acr_pull" {
     principal_id                     = module.aks.kubelet_identity_object_id
     role_definition_name             = "AcrPull"
     scope                            = module.acr.acr_id
     skip_service_principal_aad_check = true
   }