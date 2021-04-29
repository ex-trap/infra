resource "google_project" "ex_trap" {
  name       = "ex-traP"
  project_id = "ex-trap"

  billing_account = data.google_billing_account.account.id

  skip_delete = true
}

resource "google_project_service" "services" {
  for_each = toset([
    "cloudbilling.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "compute.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "oslogin.googleapis.com",
    "pubsub.googleapis.com",
    "serviceusage.googleapis.com",
  ])

  project = google_project.ex_trap.project_id
  service = each.key

  disable_on_destroy = false
}

resource "google_project_iam_member" "owner" {
  project = google_project.ex_trap.project_id
  role    = "roles/owner"

  member = "serviceAccount:${google_service_account.terraform.email}"
}

resource "google_project_iam_binding" "editors" {
  project = google_project.ex_trap.project_id
  role    = "roles/editor"

  members = [
    "group:ex-trap-sysad@googlegroups.com",
  ]
}
