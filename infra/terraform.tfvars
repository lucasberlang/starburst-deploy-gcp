
description = "GKE flink Test"

ip_range_pods = "192.168.0.0/18"

ip_range_services = "192.168.64.0/18"

istio = false

dns_cache = false

location = "global"

force_destroy = true

name ="starburst-bluetab-test"

kubernetes_version = "1.26.4-gke.500"

labels = {
  "region"             = "euw1",
  "company"            = "bt",
  "account"            = "stb",
  "project_or_service" = "terraform",
  "application"        = "",
  "resource_type"      = "",
  "resource_name"      = "",
  "environment"        = "dev",
  "responsible"        = "",
  "confidentiality"    = "false",
  "encryption"         = "false",
  "os"                 = "",
  "role"               = "",
  "cmdb_id"            = "",
  "cmdb_name"          = "",
}
