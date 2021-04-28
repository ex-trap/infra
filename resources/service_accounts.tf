# Deprecated. This file will be deleted!

resource "google_compute_instance_iam_binding" "wiki_instance_iam_binding" {
  zone          = google_compute_instance.wiki_instance.zone
  instance_name = google_compute_instance.wiki_instance.name
  role          = "roles/compute.instanceAdmin"

  members = [
    "serviceAccount:${google_service_account.resurrection_agent.email}",
  ]
}

resource "google_service_account" "wiki_agent" {
  account_id   = "wiki-agent"
  display_name = "wiki-agent"
}
