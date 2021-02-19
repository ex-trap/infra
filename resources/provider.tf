variable "project" {}

locals {
  region = "asia-northeast1"
}

terraform {
  backend "gcs" {
    prefix = "ex-trap-infra"
  }
}

provider "google" {
  project = var.project
  region  = local.region
}
