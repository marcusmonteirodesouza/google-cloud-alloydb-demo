locals {
  alloydb_sa_roles = [
    "roles/aiplatform.user"
  ]
}

resource "google_project_service_identity" "alloydb_sa" {
  provider = google-beta
  project  = data.google_project.project.project_id
  service  = "alloydb.googleapis.com"
}

resource "google_project_iam_member" "alloydb_sa" {
  for_each = toset(local.alloydb_sa_roles)
  project  = data.google_project.project.project_id
  role     = each.value
  member   = "serviceAccount:${google_project_service_identity.alloydb_sa.email}"
}