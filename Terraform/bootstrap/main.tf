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

# Create a resource group if it doesn't exist
data "azurerm_public_ip" "Data-ip" {
  name                = "IP-DOCKER01"
  resource_group_name = "RG-Monga-lab"
}


 #Virtual Machine Extension to Install IIS
resource "null_resource" "docker_provisioner" {

    triggers = {
        public_ip = data.azurerm_public_ip.Data-ip.ip_address
    }

    connection {
        type  = "ssh"
        host  = "${data.azurerm_public_ip.Data-ip.ip_address}"
        user  = "monga"
        password  = "Monga@@2023!" 
    }

    provisioner "file" {
        source  = "linux-docker.sh"
        destination  = "/tmp/linux-docker.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "sh /tmp/linux-docker.sh",
        ]
    }
} 

