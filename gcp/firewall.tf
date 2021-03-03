resource "google_compute_firewall" "opencti_app_firewall_rule" {
  name    = "opencti-app-firewall-rule"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["4000"]
  }
}
