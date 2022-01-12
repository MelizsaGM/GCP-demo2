resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "ingress"
    namespace = "elizabeth-garcia1epam-com"
  }

  spec {

    rule {
      host = "ghost-gke.demo.example"
      http {
        path {
          backend {
            service_name = "ghost-deploy-elizabeth-garcia1epam-com"
            service_port = 8080
          }

          path = "/*"
        }
      }
    }


  }
  depends_on = [helm_release.ghost]
}
  