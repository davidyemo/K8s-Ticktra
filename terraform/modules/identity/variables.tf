variable "admin_user_upn" {
  description = "Your Entra login, e.g. you@yourtenant.onmicrosoft.com"
  type        = string
}

variable "admin_group_name" {
  description = "Name of the AKS admin group"
  type        = string
  default     = "AKS-Admins"
}

variable "dev_group_name" {
  description = "Name of the AKS read-only group"
  type        = string
  default     = "AKS-Developers"
}