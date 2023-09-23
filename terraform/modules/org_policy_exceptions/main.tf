locals {
  org_policy_name_prefix = "projects/${data.google_project.project.number}/policies"

  org_policy_parent = "projects/${data.google_project.project.number}"
}

data "google_project" "project" {
}

resource "google_org_policy_policy" "gcp_resourceLocations" {
  name   = "${local.org_policy_name_prefix}/gcp.resourceLocations"
  parent = local.org_policy_parent

  spec {
    rules {
      values {
        allowed_values = [
          "in:canada-locations",
          "in:us-locations"
        ]
      }
    }
  }
}

resource "time_sleep" "org_policy_update_completed" {
  depends_on = [
    google_org_policy_policy.gcp_resourceLocations
  ]

  create_duration = "90s"
}