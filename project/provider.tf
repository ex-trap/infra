terraform {
  backend "gcs" {
    bucket = "tfstate-1078290191738"
    prefix = "project"
  }
}

provider "google" {
  project = "ex-trap"
  region  = local.region
}

locals {
  region = "asia-northeast1"
}
