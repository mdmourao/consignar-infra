terraform {
  required_providers {
    google = {
      version = "5.29.1"
    }
  }
}

provider "google" {
  project     = var.project_name
  region      = var.region
  credentials = "./environments/prod/prod-martim-miscellaneous-905948115973.json"
}

provider "google-beta" {
  project     = var.project_name
  region      = var.region
  credentials = "./environments/prod/prod-martim-miscellaneous-905948115973.json"
}
