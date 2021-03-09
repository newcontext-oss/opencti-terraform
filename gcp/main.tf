# Configure Google Cloud provider
provider "google" {
  credentials = file(var.credentials)
  project     = var.project_id
  region      = var.region
}

# Enable Cloud Resource Manager (so we can enable Compute Engine below)
resource "google_project_service" "resource_manager" {
  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = false
}

# Enable Compute Engine API
resource "google_project_service" "compute_api" {
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# Enable IAM API
resource "google_project_service" "iam_api" {
  service = "iam.googleapis.com"
  disable_on_destroy = false
}

locals {
  connectors_script_name = "opencti-connectors.sh"
  install_script_name    = "opencti-installer.sh"
}
