# Configure Google Cloud provider
provider "google" {
  credentials = file("${var.credentials}")
  project     = var.project_id
  region      = var.region
}
