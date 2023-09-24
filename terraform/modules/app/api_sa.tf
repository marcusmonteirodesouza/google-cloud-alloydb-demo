locals {
  api_sa_roles = [
    "roles/alloydb.client"
  ]
}

resource "google_service_account" "api" {
  account_id   = "api-sa"
  display_name = "API Service Account"
}

resource "google_project_iam_member" "api_sa" {
  for_each = toset(local.api_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.api.email}"
}