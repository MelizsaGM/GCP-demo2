############################################
#Creating a cluster                        #
############################################

data "google_client_config" "default" {}


module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = "gke-test-1"
  regional                   = true
  region                     = "us-central1"
  zones                      = ["us-central1-b"]
  network                    = "demo-network"
  subnetwork                 = "demo-subnet"
  ip_range_pods              = "demo-subnet-secondary-01"
  ip_range_services          = "demo-subnet-secondary-02"
  http_load_balancing        = true
  horizontal_pod_autoscaling = false
  network_policy             = false

  node_pools = [
    {
      name           = "node-pool-1"
      machine_type   = "n1-standard-1"
      autoscaling    = true
      node_locations = "us-central1-b" //list zones
      #node_count                 = 2               //Number of nodes
      local_ssd_count            = 0
      disk_size_gb               = 50
      disk_type                  = "pd-standard"
      image_type                 = "COS"
      auto_repair                = true
      auto_upgrade               = true
      preemptible                = false
      master_authorized_networks = "177.245.212.95"

    },
  ]

  node_pools_labels = {
    all = {}

    node-pool-1 = {
      node-pool-1 = true
    }
  }
  node_pools_tags = {
    all = []

    node-pool-1 = [
      "node-pool-1",
    ]
  }

  depends_on = [module.vpc] #[google_compute_network.vpc_network]
}