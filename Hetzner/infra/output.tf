
output "app-1-public-ip" {
  value = hcloud_server.app-1.ipv4_address
}

output "app-2-public-ip" {
  value = hcloud_server.app-2.ipv4_address
}

output "db-1-public-ip" {
  value = hcloud_server.db-1.ipv4_address
}
