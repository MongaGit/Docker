locals { 
nsgrules = {

    ## Project Zomboid
    Project_Zomboid = {
      name                       = "Project_Zomboid"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "16260-16265"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    ## Counter-Strike-GO
    Counter-Strike-GO = {
      name                       = "Counter-Strike-GO"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "27015-27020"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }


    ## SSH
    SSH = {
      name                       = "SSH"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
   ## RDP
    rdp = {
      name                       = "rdp"
      priority                   = 201
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range    = "3389"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
    ##HTTP
    http = {
      name                       = "http"
      priority                   = 202
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
 
}