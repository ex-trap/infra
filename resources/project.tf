data "google_project" "ex_trap" {
}

resource "google_project_iam_member" "dns_admin" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.certbot.email}"
}

resource "google_project_iam_member" "log_writer" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.certbot.email}"
}

resource "google_project_iam_member" "builds_editor" {
  role   = "roles/cloudbuild.builds.editor"
  member = "serviceAccount:${google_service_account.renew_cert_trigger.email}"
}
