
variable "region" {
  description = "fixture"
  type        = string
  default     = "europe-west1"
}

variable "project_id" {
  description = "fixture"
  type        = string
  default     = "practica-cloud-286009"
}

######
# Vars
######

variable "description" {
  description = "fixture"
  type        = string
}

variable "ip_range_pods" {
  description = "fixture"
  type        = string
}

variable "ip_range_services" {
  description = "fixture"
  type        = string
}

variable "istio" {
  description = "fixture"
  type        = bool
}

variable "dns_cache" {
  description = "fixture"
  type        = bool
}

variable "location" {
  description = "fixture"
  type        = string
}

variable "name" {
  description = "Bucket name suffix."
  type        = string
}

variable "force_destroy" {
  description = "Optional map to set force destroy keyed by name, defaults to false."
  type        = bool
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters nodes"
  type        = string
}

######
# Tags
######

variable "labels" {
  description = "fixture"
  type        = map(string)
}