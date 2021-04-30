resource "google_service_account" "necromancer" {
  account_id   = "necromancer"
  display_name = "necromancer"
}

data "archive_file" "resurrect_source" {
  type        = "zip"
  output_path = "resurrect-source.zip"

  dynamic "source" {
    for_each = [
      "../resurrection/index.js",
      "../resurrection/package.json",
      "../resurrection/package-lock.json",
    ]

    content {
      filename = basename(source.value)
      content  = file(source.value)
    }
  }
}

resource "google_storage_bucket_object" "resurrect_source" {
  name   = "resurrect-source-${data.archive_file.resurrect_source.output_md5}.zip"
  bucket = google_storage_bucket.resurrect_source.name
  source = data.archive_file.resurrect_source.output_path
}

resource "google_storage_bucket" "resurrect_source" {
  name     = "resurrect-source-${data.google_project.ex_trap.number}"
  location = local.region
}

resource "google_cloudfunctions_function" "resurrect" {
  name = "resurrect"

  runtime             = "nodejs14"
  entry_point         = "resurrect"
  timeout             = 540
  available_memory_mb = 128

  service_account_email = google_service_account.necromancer.email
  source_archive_bucket = google_storage_bucket.resurrect_source.name
  source_archive_object = google_storage_bucket_object.resurrect_source.name

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.call_of_the_dead.id
  }
}

resource "google_pubsub_topic" "call_of_the_dead" {
  name = "call-of-the-dead"
}
resource "google_pubsub_topic_iam_binding" "call_of_the_dead_publisher" {
  topic = google_pubsub_topic.call_of_the_dead.name
  role  = "roles/pubsub.publisher"

  members = [
    "serviceAccount:${google_service_account.midorigaoka.email}",
  ]
}
