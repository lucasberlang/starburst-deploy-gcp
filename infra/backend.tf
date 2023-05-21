
data "google_client_config" "default" {
  provider = google-beta
}

terraform {
  required_version = ">= 0.13"
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = " ~> 2.0"
    }
    kubernetes = "~> 2.3.2"
  }
  backend "gcs" {
    bucket  = "go-eu-bluetab-cloud-state-cs01-dev"
    prefix  = "starburst-deploy-gcp/state"
  }
}


provider "kubernetes" {
  host                   = module.gke-starburst.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke-starburst.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.gke-starburst.endpoint
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke-starburst.ca_certificate)
  }
}
