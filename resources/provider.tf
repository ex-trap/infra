terraform {
  backend "gcs" {
    bucket = "tfstate-1078290191738"
    prefix = "resources"
  }
}

provider "google" {
  project = "ex-trap"
  region  = local.region
  zone    = "${local.region}-b"
}

locals {
  region = "asia-northeast1"
}
