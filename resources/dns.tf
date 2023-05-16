locals {
  domain = "ex.trap.jp"
}

resource "google_dns_managed_zone" "ex_trap_jp" {
  name     = "ex-trap-jp"
  dns_name = "${local.domain}."
}

resource "google_dns_record_set" "suzukakedai" {
  name         = "suzukakedai.${google_dns_managed_zone.ex_trap_jp.dns_name}"
  managed_zone = google_dns_managed_zone.ex_trap_jp.name

  type    = "A"
  ttl     = 300
  rrdatas = [google_compute_address.suzukakedai.address]
}
resource "google_dns_record_set" "q" {
  name         = "q.${google_dns_managed_zone.ex_trap_jp.dns_name}"
  managed_zone = google_dns_managed_zone.ex_trap_jp.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = [google_dns_record_set.suzukakedai.name]
}
resource "google_dns_record_set" "wiki" {
  name         = "wiki.${google_dns_managed_zone.ex_trap_jp.dns_name}"
  managed_zone = google_dns_managed_zone.ex_trap_jp.name

  type    = "CNAME"
  ttl     = 300
  rrdatas = [google_dns_record_set.suzukakedai.name]
}
