variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "region" {
  description = "Deploy region"
  type        = string
}

variable "cloud_run_web_service" {
  description = "Cloud Run Web Service"
}

variable "cloud_run_rest_service" {
  description = "Cloud Run REST Service"
}

variable "consignar_web_domain" {
  description = "Consignar Web Domain"
  type        = string
}

variable "consignar_rest_domain" {
  description = "Consignar REST Domain"
  type        = string
}

variable "consignar_domain" {
  description = "Consignar Main Domain"
  type        = string
}

variable "ip_cidr_range" {
  description = "IP Range"
  type        = string
  default     = "10.7.0.0/16"
}

variable "consignar_private_key_path" {
  description = "Consignar Private Key Path"
  type        = string
}

variable "consignar_certificate_path" {
  description = "Consignar Certificate Path"
  type        = string
}
