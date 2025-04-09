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
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "5432"
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
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}
