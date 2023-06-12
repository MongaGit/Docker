locals { 
nsgrules = {

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

    ##HTTPS
    https = {
      name                       = "https"
      priority                   = 203
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    #####################
    #### GAMES PORTS ####
    #####################
    
    ## Project Zomboid
    Project_Zomboid = {
      name                       = "Project_Zomboid"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "16260-16270"
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

    ## Minecraft
    Minecraft = {
      name                       = "Minecraft"
      priority                   = 103
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "25565-25575"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    ## Terraria
    Terraria = {
      name                       = "Terraria"
      priority                   = 104
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "7777-7787"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    ## Ark-Survival-Evolved
    Ark-Survival-Evolved = {
      name                       = "Ark-Survival-Evolved"
      priority                   = 105
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "7777-7787"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    ## Rust
    Rust = {
      name                       = "Rust"
      priority                   = 106
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "28015-28025"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    ## Valheim
    Valheim = {
      name                       = "Valheim"
      priority                   = 107
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "2456-2466"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    ## Stardew-Valley
    Stardew-Valley = {
      name                       = "Stardew-Valley"
      priority                   = 108
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "24642-24652"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    ## DayZ
    DayZ = {
      name                       = "DayZ"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "2302-2312"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

    ## Garrys-Mod
    Garrys-Mod = {
      name                       = "Garrys-Mod"
      priority                   = 109
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "27015-27025"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
}