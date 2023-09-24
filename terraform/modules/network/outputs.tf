output "network_name" {
  value = module.vpc.network_name
}

output "alloydb_region_subnet_name" {
  value = module.vpc.subnets["${var.alloydb_region}/${local.alloydb_region_subnet_name}"].name
}

output "allow_ssh_from_iap_network_tag" {
  value = local.allow_ssh_from_iap_network_tag
}

output "private_service_access_google_compute_global_address_name" {
  value = google_compute_global_address.google_managed_services_range.name
}

output "private_service_access_peering_completed" {
  value = null_resource.dependency_setter.id
}