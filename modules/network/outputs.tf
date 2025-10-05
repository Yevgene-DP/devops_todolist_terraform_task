output "subnet_id" {
  value = azurerm_subnet.main.id
}

output "public_ip_address" {
  value = azurerm_public_ip.main.ip_address
}