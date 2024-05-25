variable "region" {
  description = "Deploy region"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "repository_id" {
  description = "Repository ID"
  type        = string
}

variable "irs_ui_name" {
  description = "Consignar Image Name"
  type        = string
}

variable "irs_api_name" {
  description = "Consignar REST API Image Name"
  type        = string
}

variable "irs_api_port" {
  description = "Port number the IRS API listens on"
  type        = number
}

variable "irs_ui_port" {
  description = "Port number the IRS UI listens on"
  type        = number
}

variable "DB_HOST" {
  description = "Database Host"
  type        = string
}

variable "DB_PASSWORD" {
  description = "Database Password"
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
