
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "ticktra-aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "ticktraaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2als_v6"
  }
node_provisioning_profile {
    mode = "Manual"
  }
  identity {
    type = "SystemAssigned"
  }

network_profile {
    network_plugin = "azure"
    network_plugin_mode = "overlay"
    service_cidr   = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
}

}