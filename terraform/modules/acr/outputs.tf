output "acr_id" {
  description = "Resource ID of the container registry, used for the AcrPull role assignment"
  value       = azurerm_container_registry.acr.id
}

output "login_server" {
  description = "Login server URL of the container registry"
  value       = azurerm_container_registry.acr.login_server
}