

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
    
    ## OS Config
    "VM_Name"               = "SRV-DOCKER"
    "linux_admin_username"  = "monga"
    "linux_admin_password"  = "Monga@@2023!"
    "size"                  = "Standard_F2"
    ## Disk type
    "storage_acc_type"      = "Standard_LRS"
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
