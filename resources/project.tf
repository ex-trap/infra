data "google_project" "ex_trap" {
}

resource "google_project_iam_member" "secretmanager_admin" {
  project = data.google_project.ex_trap.project_id
  role    = "roles/secretmanager.admin"
  member  = "group:ex-trap-sysad@googlegroups.com"
}

resource "google_project_iam_member" "dns_admin" {
  project = data.google_project.ex_trap.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.certbot.email}"
}

resource "google_project_iam_member" "log_writer" {
  project = data.google_project.ex_trap.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.certbot.email}"
}

resource "google_project_iam_member" "builds_editor" {
  project = data.google_project.ex_trap.project_id
  role    = "roles/cloudbuild.builds.editor"
  member  = "serviceAccount:${google_service_account.renew_cert_trigger.email}"
}
