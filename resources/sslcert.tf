resource "google_service_account" "certbot" {
  account_id   = "certbot"
  display_name = "certbot"
}
resource "google_service_account_iam_binding" "certbot_service_account_user" {
  service_account_id = google_service_account.certbot.name
  role               = "roles/iam.serviceAccountUser"
  members            = [google_service_account.renew_cert_trigger.member]
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
  bucket  = google_storage_bucket.certificates.name
  role    = "roles/storage.objectAdmin"
  members = [google_service_account.certbot.member]
}
resource "google_storage_bucket_iam_binding" "certificates_object_viewer" {
  bucket  = google_storage_bucket.certificates.name
  role    = "roles/storage.objectViewer"
  members = [google_service_account.suzukakedai.member]
}

resource "google_service_account" "renew_cert_trigger" {
  account_id   = "renew-cert-trigger"
  display_name = "renew-cert-trigger"
}
resource "google_cloud_scheduler_job" "renew_certificate" {
  name = "renew-certificate"

  time_zone = "Asia/Tokyo"
  schedule  = "0 6 1 * *"

  http_target {
    http_method = "POST"
    uri         = "https://cloudbuild.googleapis.com/v1/${data.google_project.ex_trap.id}/builds"

    headers = {
      "Content-Type" = "application/json"
    }
    body = base64encode(jsonencode(yamldecode(templatefile("../sslcert/cloudbuild.yaml", {
      service_account_id    = google_service_account.certbot.id,
      service_account_email = google_service_account.certbot.email,
      bucket_url            = google_storage_bucket.certificates.url,
      domain                = local.domain,
    }))))

    oauth_token {
      service_account_email = google_service_account.renew_cert_trigger.email
    }
  }
}
