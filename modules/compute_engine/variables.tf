variable "machine_type" {
  description = "The machine type to create."
  type        = string
  default     = "e2-micro"
}

variable "db_password" {
  description = "The password for the database user."
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "zone" {
  description = "Deploy Zone"
  type        = string
}

variable "network_name" {
  description = "Name of the network"
  type        = string
}

variable "subnetwork_name" {
  description = "Name of the subnetwork"
  type        = string
}
