

## "RG-" automatico no main.tf
variable "resource_group_name" {
    type = map(string)
  default = {

    "name"        = "Monga"
    "location"    = "brazilsouth"
 }
}

variable "VirtualMachine" {
  type = map(string)
  default = {
    
    ## User
    "linux_admin_username"  = "monga"
    "linux_admin_password"  = "Monga@@2023!"

    ## OS Config
    "VM_Name"               = "DOCKER01"
    "size"                  = "Standard_F2"
    "storage_account_type"  = "Standard_LRS"

    ## Source Image Reference
    "publisher"             = "Canonical"
    "offer"                 = "UbuntuServer"
    "sku"                   = "18.04-LTS"
    "version"               = "latest"
  }
}

variable "tags" {
  type        = map(string)
  default = {

    env         = "DockerServer",
    rg          = "rg-monga",
    dept        = "dev",
    costcenter  = "monga"
  }
}