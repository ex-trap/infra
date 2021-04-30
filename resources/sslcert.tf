resource "google_service_account" "sslcert" {
  account_id   = "sslcert"
  display_name = "sslcert"
}
resource "google_service_account_iam_binding" "sslcert_service_account_user" {
  service_account_id = google_service_account.sslcert.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${google_service_account.cron_sslcert.email}",
  ]
}

resource "google_storage_bucket" "certificates" {
  name     = "certificates-${data.google_project.ex_trap.number}"
  location = local.region

  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
resource "google_storage_bucket_iam_binding" "certificates_object_admin" {
  bucket = google_storage_bucket.certificates.name
  role   = "roles/storage.objectAdmin"

  members = [
    "serviceAccount:${google_service_account.sslcert.email}",
  ]
}

resource "google_secret_manager_secret" "zerossl_email" {
  secret_id = "zerossl-email"

  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_iam_binding" "zerossl_email_secret_accessor" {
  secret_id = google_secret_manager_secret.zerossl_email.id
  role      = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.sslcert.email}",
  ]
}

resource "google_secret_manager_secret" "zerossl_apikey" {
  secret_id = "zerossl-apikey"

  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_iam_binding" "zerossl_apikey_secret_accessor" {
  secret_id = google_secret_manager_secret.zerossl_apikey.id
  role      = "roles/secretmanager.secretAccessor"

  members = [
    "serviceAccount:${google_service_account.sslcert.email}",
  ]
}

resource "google_service_account" "cron_sslcert" {
  account_id   = "cron-sslcert"
  display_name = "cron-sslcert"
}

resource "google_cloud_scheduler_job" "renew_certificate" {
  name      = "renew-certificate"
  schedule  = "0 12 1 */2 *"
  time_zone = "Asia/Tokyo"

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/${data.google_project.ex_trap.id}/builds"

    headers = {
      "Content-Type" = "application/json"
    }
    body = base64encode(
      jsonencode(
        yamldecode(
          format(
            replace(
              file("../sslcert/cloudbuild.yaml"),
              "{{domain}}",
              "ex.trap.jp",
            ),
            google_service_account.sslcert.id,
            google_storage_bucket.certificates.url,
          )
        )
      )
    )

    oauth_token {
      service_account_email = google_service_account.cron_sslcert.email
    }
  }
}
