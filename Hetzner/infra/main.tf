terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

# Configure the Hetzner Cloud Provider
provider "hcloud" {}

resource "hcloud_network" "main-net" {
  name     = "main-net"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "app-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.main-net.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_network_subnet" "db-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.main-net.id
  network_zone = "eu-central"
  ip_range     = "10.0.100.0/24"
}

resource "hcloud_server" "app-1" {
  name        = "app-1-serv"
  server_type = "cx22"
  image       = "ubuntu-24.04"
  location    = "fsn1"
  firewall_ids = [ hcloud_firewall.app-fw.id ]

  ssh_keys = [
    "hetzner_key"
  ]

  network {
    network_id = hcloud_network.main-net.id
    ip         = "10.0.1.5"
  }

  depends_on = [
    hcloud_network_subnet.app-subnet,
    hcloud_firewall.app-fw
  ]
}

resource "hcloud_server" "app-2" {
  name        = "app-2-serv"
  server_type = "cx22"
  image       = "ubuntu-24.04"
  location    = "fsn1"
  firewall_ids = [ hcloud_firewall.app-fw.id ]

  ssh_keys = [
    "hetzner_key"
  ]

  network {
    network_id = hcloud_network.main-net.id
    ip         = "10.0.1.6"
  }

  depends_on = [
    hcloud_network_subnet.app-subnet,
    hcloud_firewall.app-fw
  ]
}

resource "hcloud_server" "db-1" {
  name        = "db-1-serv"
  server_type = "ccx13"
  image       = "ubuntu-24.04"
  location    = "fsn1"
  firewall_ids = [ hcloud_firewall.db-fw.id]

  ssh_keys = [
    "hetzner_key"
  ]

  network {
    network_id = hcloud_network.main-net.id
    ip         = "10.0.100.5"
  }

  depends_on = [
    hcloud_network_subnet.db-subnet,
    hcloud_firewall.db-fw
  ]
}

resource "hcloud_firewall" "db-fw" {
  name = "db-fw-0.1"

    rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "10.0.0.0/16",
    ]
  }
    rule {
    direction = "in"
    protocol  = "tcp"
    port = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

    rule {
    direction = "in"
    protocol  = "tcp"
    port = "5432"
    source_ips = [
      "10.0.0.0/16",
    ]
  }
}

resource "hcloud_firewall" "app-fw" {
  name = "app-fw-0.1"

    rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
    rule {
    direction = "in"
    protocol  = "tcp"
    port = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

    rule {
    direction = "in"
    protocol  = "tcp"
    port = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

    rule {
    direction = "in"
    protocol  = "tcp"
    port = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

output "app-1-public-ip" {
  value = hcloud_server.app-1.ipv4_address
}

output "app-2-public-ip" {
  value = hcloud_server.app-2.ipv4_address
}

output "db-1-public-ip" {
  value = hcloud_server.db-1.ipv4_address
}


