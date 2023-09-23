data "google_project" "project" {
}

data "google_compute_network" "app" {
  name = var.network_name
}