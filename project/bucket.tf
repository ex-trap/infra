resource "google_storage_bucket" "tfstate" {
  project  = google_project.ex_trap.project_id
  name     = "tfstate-${google_project.ex_trap.number}"
  location = "asia-northeast1"

  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
