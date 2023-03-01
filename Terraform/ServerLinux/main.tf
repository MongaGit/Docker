
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#Create the Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "RG-${var.resource_group_name["name"]}"
  location = var.resource_group_name["location"]
  tags     = var.tags
}


resource "azurerm_virtual_network" "vnet" {
  name                = "vNET-${var.resource_group_name["name"]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}
resource "azurerm_subnet" "subnet" {
  name                 = "sNet-Local"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "NSG-${var.resource_group_name["name"]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

}
resource "azurerm_network_security_rule" "rules" {
  for_each                    = local.nsgrules 
  name                        = each.key
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

## Storage Account
resource "azurerm_storage_account" "storage_account" {
  name                      = var.VirtualMachine["linux_admin_username"]
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  tags                      = var.tags
}

## Storage Container
resource "azurerm_storage_container" "storage_container" {
  name                  = "storage-${var.VirtualMachine["linux_admin_username"]}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}


## Associate VM NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "VM-nsg-association" {
  depends_on=[azurerm_resource_group.rg]
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

## Get a Static Public IP
resource "azurerm_public_ip" "VM-ip" {
  depends_on=[azurerm_resource_group.rg] 
  name                = "IP-${var.VirtualMachine["VM_Name"]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  tags                = var.tags
}

## Create Network Card for linux VM
resource "azurerm_network_interface" "VM-nic" {
  depends_on = [azurerm_resource_group.rg]
  name                = "NIC-${var.VirtualMachine["VM_Name"]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.VM-ip.id
  }
}

## Create Linux VM with linux server
resource "azurerm_virtual_machine" "VM" {
  depends_on=[azurerm_network_interface.VM-nic]

  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  name                  = var.VirtualMachine["VM_Name"]
  network_interface_ids = [azurerm_network_interface.VM-nic.id]
  vm_size               = var.VirtualMachine["size"]
  tags                  = var.tags 

  storage_image_reference {
    publisher = var.VirtualMachine["publisher"]
    offer     = var.VirtualMachine["offer"]
    sku       = var.VirtualMachine["sku"]    
    version   = var.VirtualMachine["version"]
  }
  
  storage_os_disk {
    name          = "DISK-${var.VirtualMachine["VM_Name"]}"
    vhd_uri       = "${azurerm_storage_account.storage_account.primary_blob_endpoint}${azurerm_storage_container.storage_container.name}/DISK-${var.VirtualMachine["VM_Name"]}.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = var.VirtualMachine["VM_Name"]
    admin_username = var.VirtualMachine["linux_admin_username"]
    admin_password = var.VirtualMachine["linux_admin_password"]
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }

}

resource "azurerm_virtual_machine_extension" "Docker_Install" {
  name                 = var.VirtualMachine["VM_Name"] 
  virtual_machine_id   = azurerm_virtual_machine.VM.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

#  settings = <<SETTINGS
# {
#  "commandToExecute": "hostname && uptime"
# }
#SETTINGS

  protected_settings = <<PROT
  {
      "script": "${base64encode(file(var.scfile))}"
  }
  PROT
   
}

## Execute Bash Command
#resource "azurerm_virtual_machine_extension" "test" {
#  name                 = "hostname"
#  location             = "${azurerm_resource_group.rg.location}"
#  resource_group_name  = "${azurerm_resource_group.rg.name}"
#  virtual_machine_name = "${azurerm_linux_virtual_machine.VM.computer_name}"
#  publisher            = "Microsoft.OSTCExtensions"
#  type                 = "CustomScriptForLinux"
#  type_handler_version = "1.2"
#
#  settings = <<SETTINGS
#  {
#  "fileUris": ["https://sag.blob.core.windows.net/sagcont/install_nginx_ubuntu.sh"],
#    "commandToExecute": "sh install_nginx_ubuntu.sh"
#  }
#SETTINGS
#
#}
#
### Data template Bash bootstrapping file
#data "template_file" "linux-vm-cloud-init" {
#  template = file("linux-vm-docker.sh")
#}



