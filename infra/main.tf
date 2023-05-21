
provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}


module "network" {
  source = "git@github.com:lucasberlang/gcp-network.git?ref=v1.0.0"

  project_id         = var.project_id
  description        = var.description
  enable_nat_gateway = true
  offset             = 1

  intra_subnets = [
    {
      subnet_name           = "private-subnet01"
      subnet_ip_cidr        = "10.0.0.0/24"
      subnet_private_access = false
      subnet_region         = var.region
    }
  ]

  secondary_ranges = {
    private-subnet01 = [
      {
        range_name    = "private-subnet01-01"
        ip_cidr_range = var.ip_range_pods
      },
      {
        range_name    = "private-subnet01-02"
        ip_cidr_range = var.ip_range_services
      },
    ]
  }

  labels = var.labels
}

resource "google_storage_bucket" "gcs_starburst" {
  name          = var.name
  location      = "EU"
  force_destroy = var.force_destroy
}

module "gke-starburst" {
  source = "git@github.com:lucasberlang/gcp-gke.git?ref=v1.1.0"

  project_id              = var.project_id
  name                    = "starburst"
  regional                = true
  region                  = var.region
  network                 = module.network.network_name
  subnetwork              = "go-euw1-bt-stb-private-subnet01-dev"
  ip_range_pods           = "private-subnet01-01"
  ip_range_services       = "private-subnet01-02"
  enable_private_endpoint = false
  enable_private_nodes    = false
  master_ipv4_cidr_block  = "172.16.0.0/28"
  workload_identity       = false
  kubernetes_version      = var.kubernetes_version
  
  gce_persistent_disk_csi_driver = true

  master_authorized_networks = [
    {
      cidr_block   = module.network.intra_subnet_ips.0
      display_name = "VPC"
    },
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "shell"
    }
  ]

  cluster_autoscaling = {
    enabled             = true,
    autoscaling_profile = "BALANCED",
    max_cpu_cores       = 300,
    max_memory_gb       = 940,
    min_cpu_cores       = 24,
    min_memory_gb       = 90,
  }


  node_pools = [
    {
      name         = "default-node-pool"
      machine_type = "e2-standard-16"
      auto_repair  = false
      auto_upgrade = false
    },
  ]
  
  node_labels = {
    "starburstpool" = "default-node-pool"
  }

  istio     = var.istio
  dns_cache = var.dns_cache
  labels    = var.labels
}
