output "terraform_tfvars" {
  value = google_secret_manager_secret.terraform_tfvars.id
}

output "terraform_tfstate_bucket" {
  value = google_storage_bucket.terraform_tfstate.name
}
