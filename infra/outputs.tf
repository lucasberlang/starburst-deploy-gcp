
output "cluster_name_starburst" {
  description = "The GKE identifier"
  value       = module.gke-starburst.name
}

output "endpoint_gke_starburst" {
  description = "The GKE endpoint"
  value       = module.gke-starburst.endpoint
  sensitive   = true
}

output "service_account_starburst" {
  description = "The e-mail address of the service account"
  value       = module.gke-starburst.svc_account_email
}

output "ca_certificate" {
  sensitive   = true
  description = "The cluster CA certificate (base64 encoded)"
  value       =  module.gke-starburst.ca_certificate
}