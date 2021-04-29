resource "google_service_account" "terraform" {
  project = google_project.ex_trap.project_id

  account_id   = "terraform"
  display_name = "terraform"
}
