# Who is running Terraform (your pipeline's service principal)
data "azuread_client_config" "current" {}

# Look up your user account
data "azuread_user" "admin" {
  user_principal_name = var.admin_user_upn
}

# Admin group – full cluster access
resource "azuread_group" "aks_admins" {
  display_name     = var.admin_group_name
  security_enabled = true
  owners = [
    data.azuread_client_config.current.object_id,
    data.azuread_user.admin.object_id,
  ]
}

# Add you to the admin group
resource "azuread_group_member" "admin" {
  group_object_id  = azuread_group.aks_admins.object_id
  member_object_id = data.azuread_user.admin.object_id
}

# Developer group – read-only access
resource "azuread_group" "aks_devs" {
  display_name     = var.dev_group_name
  security_enabled = true
  owners = [
    data.azuread_client_config.current.object_id,
    data.azuread_user.admin.object_id,
  ]
}