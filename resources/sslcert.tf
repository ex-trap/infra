resource "google_service_account" "certbot" {
  account_id   = "certbot"
  display_name = "certbot"
}
resource "google_service_account_iam_binding" "certbot_service_account_user" {
  service_account_id = google_service_account.certbot.name
  role               = "roles/iam.serviceAccountUser"

  members = [
    "serviceAccount:${google_service_account.renew_cert_trigger.email}",
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
    "serviceAccount:${google_service_account.certbot.email}",
  ]
}
resource "google_storage_bucket_iam_binding" "certificates_object_viewer" {
  bucket = google_storage_bucket.certificates.name
  role   = "roles/storage.objectViewer"

  members = [
    "serviceAccount:${google_service_account.midorigaoka.email}",
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
    "serviceAccount:${google_service_account.certbot.email}",
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
    "serviceAccount:${google_service_account.certbot.email}",
  ]
}

resource "google_service_account" "renew_cert_trigger" {
  account_id   = "renew-cert-trigger"
  display_name = "renew-cert-trigger"
}

resource "google_cloud_scheduler_job" "renew_certificate" {
  name     = "renew-certificate"
  schedule = "0 0 1 */2 *"

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
              local.domain,
            ),
            google_service_account.certbot.id,
            google_storage_bucket.certificates.url,
          )
        )
      )
    )

    oauth_token {
      service_account_email = google_service_account.renew_cert_trigger.email
    }
  }
}
