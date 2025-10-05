terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_integer" "random" {
  min = 1000
  max = 9999
}

module "network" {
  source = "./modules/network"

  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  vnet_address_prefix = var.vnet_address_prefix
  subnet_name         = var.subnet_name
  subnet_prefix       = var.subnet_prefix
  nsg_name            = var.nsg_name
  public_ip_name      = var.public_ip_name
  dns_label           = "${var.dns_label}${random_integer.random.result}"
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = var.resource_group_name
  location            = var.location
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  subnet_id           = module.network.subnet_id
  public_ip_address   = module.network.public_ip_address
  ssh_public_key      = var.ssh_public_key
}

module "storage" {
  source = "./modules/storage"

  resource_group_name = var.resource_group_name
  location            = var.location
  storage_account_name = "storagetask${random_integer.random.result}"
  container_name      = var.container_name
}