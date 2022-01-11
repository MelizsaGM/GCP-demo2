#Creates a custom network
module "vpc" {
  source = "terraform-google-modules/network/google//modules/subnets"

  project_id   = var.project_id
  network_name = "demo-network"
  subnets = [
    {
      subnet_name           = "demo-subnet"
      subnet_ip             = "10.26.4.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = "true"
    }
  ]
  secondary_ranges = {
    demo-subnet = [
      {
        range_name    = "demo-subnet-secondary-01"
        ip_cidr_range = "10.0.0.0/16"
      },
      {
        range_name    = "demo-subnet-secondary-02"
        ip_cidr_range = "10.4.0.0/19"
      }
    ]

    #subnet-02 = []
  }
  depends_on = [google_compute_network.vpc_network]
}

module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
  network_name = "demo-network"

  rules = [{
    name                    = "allow-ssh"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22", "80", "8080", "1000-2000"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
  depends_on = [google_compute_network.vpc_network]
}

resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "demo-network"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}
