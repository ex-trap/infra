resource "google_compute_instance_iam_binding" "midorigaoka_instance_admin" {
  zone          = google_compute_instance.midorigaoka.zone
  instance_name = google_compute_instance.midorigaoka.name
  role          = "roles/compute.instanceAdmin"

  members = [
    "serviceAccount:${google_service_account.resurrection_agent.email}",
  ]
}

resource "google_pubsub_topic_iam_binding" "resurrection_publisher" {
  topic = google_pubsub_topic.resurrection_topic.name
  role  = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.midorigaoka.email}",
    "serviceAccount:${google_service_account.wiki_agent.email}",
  ]
}
