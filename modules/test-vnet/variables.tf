variable "location" {
  description = "Region to install vm-series and dependencies."
}

variable "name_prefix" {
  description = "Prefix to add to all the object names here"
}

variable "peer-vnet" {}

variable "admin-password" {}

variable "route-table-id" {}