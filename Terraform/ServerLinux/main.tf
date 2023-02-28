
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

# Create the network VNET
resource "azurerm_virtual_network" "vnet" {
  name                = "vNET-${var.resource_group_name["name"]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

# Create a subNet
resource "azurerm_subnet" "subnet" {
  name                 = "sNet-Local"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

## Create Security Group to access linux
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

## Associate the linux NSG with the subnet
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
resource "azurerm_linux_virtual_machine" "VM" {
  depends_on=[azurerm_network_interface.VM-nic]
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  name                  = var.VirtualMachine["VM_Name"]
  network_interface_ids = [azurerm_network_interface.VM-nic.id]
  size                  = var.VirtualMachine["size"]
  tags                  = var.tags 
  source_image_reference {
    publisher = var.VirtualMachine["publisher"]
    offer     = var.VirtualMachine["offer"]
    sku       = var.VirtualMachine["sku"]    
    version   = var.VirtualMachine["version"]
  }
  
  os_disk {
    name                 = "DISK-${var.VirtualMachine["VM_Name"]}"
    caching              = "ReadWrite"
    storage_account_type = var.VirtualMachine["storage_account_type"]  
  }
  
  computer_name  = var.VirtualMachine["VM_Name"]
  admin_username = var.VirtualMachine["linux_admin_username"]
  admin_password = var.VirtualMachine["linux_admin_password"]
  disable_password_authentication = false
}

## Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("linux-vm-docker.sh")
}



