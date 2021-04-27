resource "google_compute_address" "wiki_ip" {
  name = "wiki"
}

resource "google_compute_instance" "wiki_instance" {
  name         = "wiki"
  machine_type = "e2-micro"
  zone         = "${local.region}-b"

  allow_stopping_for_update = true

  tags = [local.tag_allow_from_cloudflare]

  network_interface {
    network = data.google_compute_network.default_network.name
    access_config {
      nat_ip = google_compute_address.wiki_ip.address
    }
  }

  boot_disk {
    initialize_params {
      size  = 10
      image = "cos-cloud/cos-dev"
    }
  }

  scheduling {
    preemptible       = true
    automatic_restart = false
  }

  service_account {
    email  = google_service_account.wiki_agent.email
    scopes = ["pubsub"]
  }

  metadata = {
    shutdown-script    = file("../resurrection/shutdown-script.py")
    resurrection-topic = google_pubsub_topic.resurrection_topic.id
  }

  depends_on = [google_compute_project_metadata.ssh_keys]
}
