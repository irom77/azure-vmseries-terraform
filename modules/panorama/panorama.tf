# Create a public IP for management
resource "azurerm_public_ip" "panorama-pip-mgmt" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.panorama.location
  name                = "${var.name_prefix}${var.sep}${var.name_panorama_pip_mgmt}"
  resource_group_name = azurerm_resource_group.panorama.name
}

# Build the management interface
resource "azurerm_network_interface" "mgmt" {
  location            = azurerm_resource_group.panorama.location
  name                = "${var.name_prefix}${var.sep}${var.name_mgmt}"
  resource_group_name = azurerm_resource_group.panorama.name
  ip_configuration {
    subnet_id                     = var.subnet_mgmt.id
    name                          = "${var.name_prefix}-ip-mgmt"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.panorama-pip-mgmt.id
  }
}


# Build the Panorama VM
resource "azurerm_virtual_machine" "panorama" {
  name                  = "${var.name_prefix}${var.sep}${var.name_panorama}"
  location              = azurerm_resource_group.panorama.location
  resource_group_name   = azurerm_resource_group.panorama.name
  network_interface_ids = [azurerm_network_interface.mgmt.id]
  vm_size               = var.panorama_size

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "panorama"
    sku       = var.panorama_sku
    version   = var.panorama_version
  }
  storage_os_disk {
    name              = "${var.name_prefix}PanoramaDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = var.username
    admin_password = var.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  plan {
    name      = "byol"
    product   = "panorama"
    publisher = "paloaltonetworks"
  }
  provisioner "local-exec" {
    environment = {
      USERNAME=var.username
      PASSWORD=var.password
    }
    command = "${path.cwd}/${path.module}/configure_panorama.exe -pip ${azurerm_network_interface.mgmt.private_ip_address} -pp ${azurerm_public_ip.panorama-pip-mgmt.ip_address} -sk ${azurerm_storage_account.bootstrap-storage-account.primary_access_key} -oss ${azurerm_storage_share.outbound-bootstrap-storage-share.name} -iss ${azurerm_storage_share.inbound-bootstrap-storage-share.name} -sn ${azurerm_storage_account.bootstrap-storage-account.name}"
  }
}
