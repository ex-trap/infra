data "google_billing_account" "account" {
  display_name = "ex-traP"
}

resource "google_billing_account_iam_binding" "billing_user" {
  billing_account_id = data.google_billing_account.account.id
  role               = "roles/billing.user"

  members = [
    "serviceAccount:${google_service_account.terraform_agent.email}",
  ]
}

resource "google_billing_account_iam_binding" "billing_viewer" {
  billing_account_id = data.google_billing_account.account.id
  role               = "roles/billing.viewer"

  members = [
    "serviceAccount:${google_service_account.terraform_agent.email}",
  ]
}
