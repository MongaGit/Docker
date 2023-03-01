

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
    "size"                  = "Standard_DS3_v2"
    "storage_account_type"  = "Standard_LRS"

    ## Source Image Reference
    "publisher"             = "canonical"  #"Canonical"
    "offer"                 = "0001-com-ubuntu-server-focal"  #"UbuntuServer"
    "sku"                   = "20_04-lts"  #"20.04-LTS"
    "version"               = "latest"
  }
}

variable "scfile" {
  type    = string
  default = "linux-vm-docker.bash"
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

## Sizes

# D2as_v4   ## CPU 02 | RAM 08 ($ 78.11)
# B2ms      ## CPU 02 | RAM 04 ($ 66.43)
##
# B4ms      ## CPU 04 | RAM 16 ($132.86) 
##
# E4_v5     ## CPU 04 | RAM 32 ($205.86) 
# DS3_v2    ## CPU 04 | RAM 14 ($250.39)
##
# D8s_v5    ## CPU 08 | RAM 32 ($312.44)

