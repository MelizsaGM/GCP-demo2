resource "helm_release" "ghost" {
  namespace = "elizabeth_garcia1@epam_com"
  name       = "ghost-deploy"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "ghost"
  create_namespace = true

  set {
    name  = "service.type"
    value = "NodePort"
  }
  set {
    name  = "ghostHost"
    value = "ghost-gke.example"
  }
  set {
    name  = "replicaCount"
    value = 2
  }
}