resource "google_storage_bucket" "tfstate" {
  name     = "tfstate-${google_project.ex_trap.number}"
  location = local.region

  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
}
