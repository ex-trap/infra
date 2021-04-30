locals {
  domain = "ex.trap.jp"
}

resource "google_dns_managed_zone" "ex_trap_jp" {
  name     = "ex-trap-jp"
  dns_name = "${local.domain}."
}

resource "google_dns_record_set" "midorigaoka" {
  for_each = toset([
    "midorigaoka",
    "wiki",
    "q",
  ])

  name         = "${each.key}.${google_dns_managed_zone.ex_trap_jp.dns_name}"
  managed_zone = google_dns_managed_zone.ex_trap_jp.name

  type    = "A"
  ttl     = 300
  rrdatas = [google_compute_address.midorigaoka.address]
}
