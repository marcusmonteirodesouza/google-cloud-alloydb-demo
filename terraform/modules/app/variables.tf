variable "region" {
  type        = string
  description = "The default Google Cloud region for the created resources."
}

variable "alloydb_region" {
  type        = string
  description = "The AlloyDB region."
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network to attach resources to."
}

variable "alloydb_region_subnet_name" {
  type        = string
  description = "Subnet located in the same VPC and region as the AlloyDB instance."
}

variable "allow_ssh_from_iap_network_tag" {
  type        = string
  description = "Allow SSH from IAP network tag."
}

variable "api_sa_email" {
  type        = string
  description = "The API service account email."
}

variable "alloydb_auth_proxy_vm_sa_email" {
  type        = string
  description = "The AlloyDB auth proxy VM service account email."
}