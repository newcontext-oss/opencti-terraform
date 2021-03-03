# Startup script template
data "template_file" "startup_script" {
  template = file("../userdata/installation-wrapper-script.sh")
  vars = {
    "account_name" = "only for azure"
    "bucket_name"  = local.bucket_name
    # The wrapper script is used for multiple clouds. This defines this cloud.
    "cloud"                  = "gcp"
    "connection_string"      = "only for azure"
    "connectors_script_name" = "opencti-connectors.sh"
    "container_name"         = "only for azure"
    "install_script_name"    = "opencti-installer.sh"
    "login_email"            = var.login_email
  }
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
  metadata_startup_script = data.template_file.startup_script.rendered

  network_interface {
    network = "default"

    access_config {
      # Using defaults, but included to provide IP address.
    }
  }

  service_account {
    email = google_service_account.storage.email
    # Scopes are outlined here: https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes
    scopes = [ "cloud-platform", "storage-ro" ]
  }
}
