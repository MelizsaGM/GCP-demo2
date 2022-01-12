resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "ingress"
  }

  spec {

    rule {
      host = "ghost-gke.example"
      http {
        path {
          backend {
            service_name = "ghost-deploy"
            service_port = 80
          }

          path = "/*"
        }
      }
    }


  }
  depends_on = [helm_release.ghost]
}
  