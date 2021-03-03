# Create the service account that accesses the storage.
resource "google_service_account" "storage" {
  account_id   = "storage-service-account"
  display_name = "OpenCTI storage service account"
}

resource "google_service_account_key" "storage_key" {
  service_account_id = google_service_account.storage.name
}

# Set IAM policy on storage bucket so objects can be downloaded and associate service account with it.
data "google_iam_policy" "storage_iam" {
  binding {
    role    = "roles/storage.objectViewer"
    members = [ "serviceAccount:${google_service_account.storage.email}" ]
  }
}

resource "google_storage_bucket_iam_policy" "bucket_iam" {
  bucket      = google_storage_bucket.opencti_storage.name
  policy_data = data.google_iam_policy.storage_iam.policy_data
}
