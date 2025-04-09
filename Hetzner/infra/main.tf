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


resource "hcloud_server" "app-1" {
  name         = "app-1-serv"
  server_type  = "cx22"
  image        = "ubuntu-24.04"
  location     = "fsn1"
  firewall_ids = [hcloud_firewall.app-fw.id]

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
  name         = "app-2-serv"
  server_type  = "cx22"
  image        = "ubuntu-24.04"
  location     = "fsn1"
  firewall_ids = [hcloud_firewall.app-fw.id]

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
  name         = "db-1-serv"
  server_type  = "ccx13"
  image        = "ubuntu-24.04"
  location     = "fsn1"
  firewall_ids = [hcloud_firewall.db-fw.id]

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
