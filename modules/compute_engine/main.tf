resource "google_compute_instance" "this" {
  name                      = "db-instance"
  machine_type              = var.machine_type
  zone                      = var.zone
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = false
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnetwork_name
  }
}

output "db_internal_ip" {
  value = google_compute_instance.this.network_interface.0.network_ip
}
