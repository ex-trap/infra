resource "google_compute_address" "suzukakedai" {
  name = "suzukakedai"
}

resource "google_service_account" "suzukakedai" {
  account_id   = "suzukakedai"
  display_name = "suzukakedai"
}

resource "google_compute_firewall" "suzukakedai" {
  name    = "suzukakedai"
  network = data.google_compute_network.default.name

  source_ranges = [
    "0.0.0.0/0",
  ]
  target_service_accounts = [
    google_service_account.suzukakedai.email,
  ]

  allow {
    protocol = "tcp"
    ports = [
      "22",
      "80",
      "443",
    ]
  }
}

resource "google_compute_instance_template" "suzukakedai" {
  name         = "suzukakedai"
  machine_type = "e2-medium"

  disk {
    disk_type    = "pd-balanced"
    disk_size_gb = 30
    boot         = true
    source_image = "cos-cloud/cos-stable"
  }

  network_interface {
    network = data.google_compute_network.default.name

    access_config {
      nat_ip = google_compute_address.suzukakedai.address
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  shielded_instance_config {
    enable_vtpm                 = true
    enable_secure_boot          = true
    enable_integrity_monitoring = true
  }

  service_account {
    email  = google_service_account.suzukakedai.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    google-logging-enabled       = "true"
    google-logging-use-fluentbit = "true"

    enable-oslogin         = "TRUE"
    block-project-ssh-keys = "TRUE"

    startup-script = file("../sslcert/startup-script.py")
    certs-bucket   = google_storage_bucket.certificates.name
    certs-name     = local.domain
  }
}

resource "google_compute_health_check" "suzukakedai" {
  name = "suzukakedai"

  tcp_health_check {
    port = "22"
  }

  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 5
  unhealthy_threshold = 5
}

resource "google_compute_region_instance_group_manager" "suzukakedai" {
  name = "suzukakedai"

  base_instance_name = "suzukakedai"

  target_size = 1
  distribution_policy_zones = [
    "asia-northeast1-c",
  ]

  version {
    instance_template = google_compute_instance_template.suzukakedai.id
  }

  stateful_disk {
    device_name = google_compute_instance_template.suzukakedai.disk[0].device_name
    delete_rule = "ON_PERMANENT_INSTANCE_DELETION"
  }

  update_policy {
    type                         = "OPPORTUNISTIC"
    minimal_action               = "REPLACE"
    instance_redistribution_type = "NONE"
    max_surge_fixed              = 1
    max_unavailable_fixed        = 1
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.suzukakedai.id
    initial_delay_sec = 20
  }
}
