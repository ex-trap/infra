data "archive_file" "resurrection_source_archive" {
  type        = "zip"
  output_path = "resurrection-source.zip"

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

resource "google_storage_bucket_object" "resurrection_source" {
  name   = "resurrection-source-${data.archive_file.resurrection_source_archive.output_md5}.zip"
  bucket = google_storage_bucket.resurrection_source_bucket.name
  source = data.archive_file.resurrection_source_archive.output_path
}

resource "google_storage_bucket" "resurrection_source_bucket" {
  name     = "resurrection-source-${local.project_id}"
  location = local.region
}

resource "google_cloudfunctions_function" "resurrection" {
  name = "resurrection"

  runtime             = "nodejs14"
  entry_point         = "resurrect"
  timeout             = 540
  available_memory_mb = 128

  service_account_email = google_service_account.resurrection_agent.email
  source_archive_bucket = google_storage_bucket.resurrection_source_bucket.name
  source_archive_object = google_storage_bucket_object.resurrection_source.name

  event_trigger {
    event_type = "providers/cloud.pubsub/eventTypes/topic.publish"
    resource   = google_pubsub_topic.resurrection_topic.id
  }
}

resource "google_pubsub_topic" "resurrection_topic" {
  name = "resurrection-topic"
}

resource "google_cloud_scheduler_job" "resurrection_job_for_wiki" {
  name     = "resurrection-job-for-wiki"
  schedule = "*/15 * * * *"

  pubsub_target {
    topic_name = google_pubsub_topic.resurrection_topic.id
    data       = base64encode("zone=${google_compute_instance.wiki_instance.zone}&instance=${google_compute_instance.wiki_instance.name}&timeout=0")
  }
}
