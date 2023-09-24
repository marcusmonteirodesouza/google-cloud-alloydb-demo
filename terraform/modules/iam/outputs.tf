output "api_sa_email" {
  value = google_service_account.api.email
}

output "alloydb_auth_proxy_vm_sa_email" {
  value = google_service_account.alloydb_auth_proxy_vm.email
}