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