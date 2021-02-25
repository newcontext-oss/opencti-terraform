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

  network_interface {

  }
}
