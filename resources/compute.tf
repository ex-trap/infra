resource "google_service_account" "midorigaoka" {
  account_id   = "midorigaoka"
  display_name = "midorigaoka"
}
resource "google_compute_address" "midorigaoka" {
  name = "midorigaoka"
}
resource "google_compute_instance" "midorigaoka" {
  name         = "midorigaoka"
  machine_type = "e2-small"
  zone         = "${local.region}-b"

  allow_stopping_for_update = true

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.midorigaoka.address
    }
  }

  boot_disk {
    initialize_params {
      size  = 16
      image = "cos-cloud/cos-dev"
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  service_account {
    email  = google_service_account.midorigaoka.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin         = "TRUE"
    block-project-ssh-keys = "TRUE"

    startup-script = file("../sslcert/startup-script.py")
    certs-bucket   = google_storage_bucket.certificates.name
    certs-name     = "ex.trap.jp"

    shutdown-script    = file("../resurrection/shutdown-script.py")
    resurrection-topic = google_pubsub_topic.resurrection_topic.id
  }
}
