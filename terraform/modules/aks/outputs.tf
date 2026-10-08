output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}