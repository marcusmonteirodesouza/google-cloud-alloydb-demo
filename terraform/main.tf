provider "google" {
  project               = var.project_id
  region                = var.region
  user_project_override = true
}

provider "google-beta" {
  project               = var.project_id
  region                = var.region
  user_project_override = true
}

module "enable_apis" {
  source = "./modules/enable_apis"
}

module "org_policy_exceptions" {
  source = "./modules/org_policy_exceptions"

  depends_on = [
    module.enable_apis
  ]
}

module "network" {
  source = "./modules/network"

  alloydb_region = var.alloydb_region

  depends_on = [
    module.org_policy_exceptions.org_policy_update_completed
  ]
}

module "app" {
  source = "./modules/app"

  region                         = var.region
  alloydb_region                 = var.alloydb_region
  network_name                   = module.network.network_name
  alloydb_region_subnet_name     = module.network.alloydb_region_subnet_name
  allow_ssh_from_iap_network_tag = module.network.allow_ssh_from_iap_network_tag
}