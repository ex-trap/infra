data "google_project" "ex_trap" {
}

resource "google_project_iam_member" "certbot_is" {
  for_each = toset([
    "roles/dns.admin",
    "roles/logging.logWriter",
    "roles/publicca.externalAccountKeyCreator",
  ])

  project = data.google_project.ex_trap.project_id
  role    = each.value
  member  = google_service_account.certbot.member
}

resource "google_project_iam_member" "renew_cert_trigger_is" {
  for_each = toset([
    "roles/cloudbuild.builds.editor",
  ])

  project = data.google_project.ex_trap.project_id
  role    = each.value
  member  = google_service_account.renew_cert_trigger.member
}
