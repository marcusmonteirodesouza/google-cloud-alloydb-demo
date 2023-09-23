resource "random_uuid" "terraform_tfstate_bucket" {
}

resource "google_storage_bucket" "terraform_tfstate" {
  name     = random_uuid.terraform_tfstate_bucket.result
  location = var.region

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}
