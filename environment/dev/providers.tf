data "google_client_config" "provider" {}

data "google_container_cluster" "my_cluster" {
  project    = var.project_id
  name       = "gke-test-1"
  location   = "us-central1-b"
  depends_on = [module.gke.name]
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
