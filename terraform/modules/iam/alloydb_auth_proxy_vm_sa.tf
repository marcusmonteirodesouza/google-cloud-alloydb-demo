locals {
  alloydb_auth_proxy_vm_sa_roles = [
    "roles/alloydb.client"
  ]
}

resource "google_service_account" "alloydb_auth_proxy_vm" {
  account_id   = "alloydb-auth-proxy-vm-sa"
  display_name = "Demo App AlloyDB Auth Proxy VM service acocunt"
}

resource "google_project_iam_member" "alloydb_auth_proxy_vm_sa" {
  for_each = toset(local.alloydb_auth_proxy_vm_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.alloydb_auth_proxy_vm.email}"
}