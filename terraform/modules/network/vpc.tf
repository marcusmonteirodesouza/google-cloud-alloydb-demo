module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.3"

  project_id   = data.google_project.project.project_id
  network_name = "vpc-network"
  routing_mode = "GLOBAL"

  subnets = []
}