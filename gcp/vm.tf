# Startup script template
locals {
  startup_script = templatefile("${path.module}/../userdata/installation-wrapper-script.sh", {
    account_name           = "only for azure"
    cloud                  = "gcp"
    connection_string      = "only for azure"
    connectors_script_name = "opencti-connectors.sh"
    install_script_name    = "opencti-installer.sh"
    login_email            = var.login_email
    storage_bucket         = var.storage_bucket
  })
}

resource "google_compute_instance" "opencti_instance" {
  name         = "opencti"
  machine_type = var.machine_type
  zone         = var.zone

  # Ubuntu 20.04 LTS
  boot_disk {
    initialize_params {
      image = "ubuntu-2004-lts"
      size  = var.disk_size
    }
  }

  # Startup script
  metadata_startup_script = local.startup_script

  network_interface {
    network = "default"

    access_config {
      # Using defaults, but included to provide IP address.
    }
  }

  service_account {
    email = google_service_account.storage.email
    # Scopes are outlined here: https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes
    scopes = ["cloud-platform", "storage-ro"]
  }
}
