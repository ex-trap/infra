# Deprecated. This file will be deleted!

data "google_compute_network" "default_network" {
  name = "default"
}

locals {
  tag_allow_from_cloudflare = "allow-from-cloudflare"
}

resource "google_compute_firewall" "allow_from_cloudflare" {
  name    = local.tag_allow_from_cloudflare
  network = data.google_compute_network.default_network.name

  target_tags = [local.tag_allow_from_cloudflare]

  # Last updated: October 1, 2020
  # https://www.cloudflare.com/ips/
  source_ranges = [
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/12",
    "172.64.0.0/13",
    "131.0.72.0/22",
  ]

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}
