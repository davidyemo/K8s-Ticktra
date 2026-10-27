resource "azurerm_resource_group" "Resource_Group" {
  name     = var.resource_group_name
  location = var.location
}

module "acr" {
  source                  = "./modules/acr"
  location                = var.location
  resource_group_name     = azurerm_resource_group.Resource_Group.name
  container_registry_name = var.container_registry_name
  acr_sku                 = var.acr_sku

}

module "networking" {
  source                 = "./modules/networking"
  location               = var.location
  resource_group_name    = azurerm_resource_group.Resource_Group.name
  vnet_name              = var.vnet_name
  vnet_address_space     = var.vnet_address_space
  aks_subnet_name        = var.aks_subnet_name
  aks_subnet_prefixes    = var.aks_subnet_prefixes
  public_subnet_name     = var.public_subnet_name
  public_subnet_prefixes = var.public_subnet_prefixes
}

module "aks" {
  source                = "./modules/aks"
  location              = var.location
  resource_group_name   = azurerm_resource_group.Resource_Group.name
  subnet_id             = module.networking.subnet_id
  admin_group_object_id = [module.identity.admin_group_object_id]
  cluster_name          = var.cluster_name
  dns_prefix            = var.dns_prefix
  node_pool_name        = var.node_pool_name
  node_count            = var.node_count
  vm_size               = var.vm_size
  service_cidr          = var.service_cidr
  dns_service_ip        = var.dns_service_ip
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id                     = module.aks.kubelet_identity_object_id
  role_definition_name             = "AcrPull"
  scope                            = module.acr.acr_id
  skip_service_principal_aad_check = true
}

module "identity" {
  source         = "./modules/identity"
  admin_user_upn = var.admin_user_upn
}
