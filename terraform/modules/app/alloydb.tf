data "google_compute_zones" "alloydb_available" {
  region = var.alloydb_region
  status = "UP"
}

# AlloyDB initial user name
resource "random_password" "alloydb_initial_user_name" {
  length  = 16
  numeric = false
  special = false
  upper   = false
}

resource "google_secret_manager_secret" "alloydb_initial_user_name" {
  secret_id = "demo-app-alloydb-initial-user-name"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "alloydb_initial_user_name" {
  secret      = google_secret_manager_secret.alloydb_initial_user_name.id
  secret_data = random_password.alloydb_initial_user_name.result
}

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
  cluster_id = "demo-app-alloydb-cluster"
  location   = var.alloydb_region
  network    = data.google_compute_network.app.id

  initial_user {
    user     = random_password.alloydb_initial_user_name.result
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

# AlloyDB Auth Proxy VM. See https://cloud.google.com/alloydb/docs/auth-proxy/connect
resource "google_service_account" "alloydb_auth_proxy_vm" {
  account_id   = "alloydb-auth-proxy-vm-sa"
  display_name = "Demo App AlloyDB Auth Proxy VM service acocunt"
}

resource "google_project_iam_member" "alloydb_auth_proxy_vm_sa_alloydb_client" {
  project = data.google_project.project.project_id
  role    = "roles/alloydb.client"
  member  = "serviceAccount:${google_service_account.alloydb_auth_proxy_vm.email}"
}

data "template_file" "alloydb_auth_proxy_vm_startup_script" {
  template = file("${path.module}/alloydb-auth-proxy-vm-startup-script.sh.template")
  vars = {
    instance_uri = google_alloydb_instance.app_primary.id
  }
}

resource "google_compute_instance" "alloydb_auth_proxy" {
  name         = "alloydb-auth-proxy"
  machine_type = "f1-micro"
  zone         = data.google_compute_zones.alloydb_available.names[0]

  network_interface {
    network    = data.google_compute_network.app.id
    subnetwork = var.alloydb_region_subnet_name
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  service_account {
    email  = google_service_account.alloydb_auth_proxy_vm.email
    scopes = ["cloud-platform"]
  }

  tags = [
    var.allow_ssh_from_iap_network_tag
  ]

  metadata_startup_script = data.template_file.alloydb_auth_proxy_vm_startup_script.rendered

  depends_on = [
    google_project_iam_member.alloydb_auth_proxy_vm_sa_alloydb_client
  ]
}