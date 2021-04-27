terraform {
  backend "gcs" {
    bucket = "tfstate-1078290191738"
    prefix = "resources"
  }
}

provider "google" {
  project = "ex-trap"
  region  = local.region
}

locals {
  project_id = "1078290191738"
  region     = "asia-northeast1"
}
