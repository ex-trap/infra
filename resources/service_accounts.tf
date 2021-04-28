# Deprecated. This file will be deleted!

resource "google_service_account" "resurrection_agent" {
  account_id   = "resurrection-agent"
  display_name = "resurrection-agent"
}

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

resource "google_pubsub_topic_iam_binding" "topic_iam_binding" {
  topic = google_pubsub_topic.resurrection_topic.name
  role  = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.wiki_agent.email}",
  ]
}
