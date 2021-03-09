# Create storage bucket and add install and connectors script to it.
resource "google_storage_bucket" "opencti_storage" {
  name          = var.storage_bucket
  location      = var.region
  force_destroy = true
}

resource "google_storage_bucket_object" "opencti_install_script" {
  name   = local.install_script_name
  source = "../opencti_scripts/installer.sh"
  bucket = google_storage_bucket.opencti_storage.name
}

resource "google_storage_bucket_object" "opencti_connectors_script" {
  name   = local.connectors_script_name
  source = "../opencti_scripts/connectors.sh"
  bucket = google_storage_bucket.opencti_storage.name
}
