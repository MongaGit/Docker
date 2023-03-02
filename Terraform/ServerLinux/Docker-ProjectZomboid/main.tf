
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

################################
## Get data cfg VM Publib IP  ##
data "azurerm_public_ip" "Data-ip" {
  name                = "IP-${var.VirtualMachine["VM_Name"]}"
  resource_group_name = "RG-${var.resource_group_name["name"]}"
}

#################################
## Extension to Install Docker ##
resource "null_resource" "docker_provisioner" {
    triggers = {
        public_ip = data.azurerm_public_ip.Data-ip.ip_address
    }
    connection {
        type  = "ssh"
        host  = "${data.azurerm_public_ip.Data-ip.ip_address}"
        user  = "${var.VirtualMachine["linux_admin_username"]}"
        password  = "${var.VirtualMachine["linux_admin_password"]}"
    }
    provisioner "file" {
        source        = "Docker-Install.sh"
        destination   = "/tmp/Docker-Install.sh"
    }
    provisioner "file" {
        source        = "image-projectzomboid.sh"
        destination   = "/tmp/image-projectzomboid.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "sudo sh /tmp/Docker-Install.sh",
            "sudo docker container ls",
            "sudo sh /tmp/image-projectzomboid.sh",
            "sudo docker container ls",

            #"sudo docker run -d -t -i -e SERVERNAME='MONGA_PZServer' -p 27015:27015/tcp -p 16261:16261/udp -p 16262:16262/udp -e ADMINPASSWORD='Password@123' -e FORCEUPDATE='' -e MOD_IDS='2931602698,2931602698' -e WORKSHOP_IDS='2875848298,2849247394,2923439994,2859296947,2859296947,2859296947' --name projectzomboid lorthe/monga_projectzomboid",
            #"sudo docker container ls",
        ]
    }
} 



