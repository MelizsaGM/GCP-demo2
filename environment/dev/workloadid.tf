module "my-app-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "cron-sql"
  namespace  = "elizabeth-garcia1epam-com"
  project_id = var.project_id
  roles      = ["roles/storage.admin", "roles/compute.admin"]

  depends_on = [module.gke]
}