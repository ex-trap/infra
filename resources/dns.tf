resource "google_dns_managed_zone" "ex_trap_jp" {
  name     = "ex-trap-jp"
  dns_name = "ex.trap.jp."
}

resource "google_dns_record_set" "wiki" {
  name         = "wiki.${google_dns_managed_zone.ex_trap_jp.dns_name}"
  managed_zone = google_dns_managed_zone.ex_trap_jp.name

  type    = "A"
  ttl     = 600
  rrdatas = [google_compute_instance.wiki_instance.network_interface[0].access_config[0].nat_ip]
}
