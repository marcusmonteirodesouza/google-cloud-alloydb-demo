locals {
  alloydb_region_subnet_name = "${var.alloydb_region}-subnet"

  allow_ssh_from_iap_network_tag = "allow-ssh-from-iap"
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.3"

  project_id   = data.google_project.project.project_id
  network_name = "vpc-network"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = local.alloydb_region_subnet_name
      subnet_ip     = "10.128.0.0/20"
      subnet_region = var.alloydb_region
    }
  ]
}

resource "google_compute_router" "alloydb_region_router" {
  name    = "${var.alloydb_region}-router"
  region  = var.alloydb_region
  network = module.vpc.network_name
}

resource "google_compute_router_nat" "alloydb_region_nat" {
  name                               = "${var.alloydb_region}-nat-config"
  router                             = google_compute_router.alloydb_region_router.name
  region                             = var.alloydb_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "allow_ssh_from_iap" {
  name        = "allow-ssh-from-iap"
  network     = module.vpc.network_name
  target_tags = [local.allow_ssh_from_iap_network_tag]

  source_ranges = [
    "35.235.240.0/20",
  ]

  allow {
    protocol = "tcp"
    ports    = ["22", ]
  }
}