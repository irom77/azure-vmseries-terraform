variable "location" {
  description = "Region to install vm-series and dependencies."
}

variable "name_prefix" {
  description = "Prefix to add to all the object names here"
}

variable "vmseries_size" {
  description = "Default size for VM series"
  default     = "Standard_D5_v2"
}

variable "subnet-mgmt" {
  description = "Management subnet."
}

variable "subnet-public" {
  description = "External/public subnet"
}

variable "subnet-private" {
  description = "internal/private subnet"
}

variable "bootstrap-storage-account" {
  description = "Storage account setup for bootstrapping"
}

variable "inbound-bootstrap-share-name" {
  description = "File share for bootstrap config"
}

variable "outbound-bootstrap-share-name" {
  description = "File share for bootstrap config"
}

variable "username" {
  description = "Username"
  default     = "panadmin"
}

variable "password" {
  description = "Password for VM Series firewalls"
}
variable "vm_series_sku" {
  default = "bundle2"
}
variable "vm_series_version" {
  default = "9.0.4"
}

variable "vm_series_count" {
  default = 1
}

variable "vhd-container" {
}

variable "public_backend_pool_id" {
  description = "The LB pool to associate the public interface with."
}
variable "private_backend_pool_id" {
  description = "The LB pool to associate the private interface with."
}

variable "resource_group" {
  description = "The resource group for VM series deployment"
}