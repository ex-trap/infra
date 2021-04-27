resource "google_service_account" "terraform_agent" {
  project = google_project.ex_trap.project_id

  account_id   = "terraform-agent"
  display_name = "terraform-agent"
}
