locals {
  enable_apis = [
    "alloydb.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "orgpolicy.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
  ]
}

resource "google_project_service" "enable_apis" {
  for_each                   = toset(local.enable_apis)
  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = true
}
