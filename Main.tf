terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.77.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "7454c207-6484-4225-8771-680428895c08"
  features {}
}

resource "azurerm_resource_group" "DevOps_RG" {
  name     = "Jugal_RG"
  location = "West US"

  tags = {
    environment = "Test"
  }
}



resource "azurerm_virtual_network" "jugal_vnet" {
  name                = "jugalvnet"
  address_space       = ["192.168.1.0/24"]
  location = azurerm_resource_group.DevOps_RG.location
  resource_group_name = azurerm_resource_group.DevOps_RG.name
}

resource "azurerm_subnet" "Jugal_Subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.DevOps_RG.name
  virtual_network_name = azurerm_virtual_network.jugal_vnet.name

  address_prefixes = ["192.168.1.224/27"]
}


resource "azurerm_public_ip" "Juagal_PublicIP" {
  name                = "Jugal_PIP"
  location            = azurerm_resource_group.DevOps_RG.location
  resource_group_name = azurerm_resource_group.DevOps_RG.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "Jugal_Bastion" {
  name                = "JugalBastion"
  location = azurerm_resource_group.DevOps_RG.location
  resource_group_name = azurerm_resource_group.DevOps_RG.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.Jugal_Subnet.id
    public_ip_address_id = azurerm_public_ip.Juagal_PublicIP.id
  }
}