terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none" 
  features {}
  subscription_id = "xxxx-xxxx-xxxx"
  client_id       = "xxxx-xxxx-xxxx"
  client_secret   = "xxxx-xxxx-xxxx"
  tenant_id       = "xxxx-xxxx-xxxx"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West US"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}