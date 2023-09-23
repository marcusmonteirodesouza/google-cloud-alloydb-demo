# AlloyDB initial user password
resource "random_password" "alloydb_initial_user_password" {
  length = 16
}

resource "google_secret_manager_secret" "alloydb_initial_user_password" {
  secret_id = "demo-app-alloydb-initial-user-password"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "alloydb_initial_user_password" {
  secret      = google_secret_manager_secret.alloydb_initial_user_password.id
  secret_data = random_password.alloydb_initial_user_password.result
}

# AlloyDB
resource "google_alloydb_cluster" "app" {
  cluster_id   = "demo-app-alloydb-cluster"
  location     = var.alloydb_region
  network      = data.google_compute_network.app.id
  display_name = "Demo App AlloyDB cluster"

  initial_user {
    user     = "postgres"
    password = random_password.alloydb_initial_user_password.result
  }
}

resource "google_alloydb_instance" "app_primary" {
  cluster       = google_alloydb_cluster.app.name
  instance_id   = "demo-app-alloydb-primary-instance"
  instance_type = "PRIMARY"
  machine_config {
    cpu_count = 2
  }
}