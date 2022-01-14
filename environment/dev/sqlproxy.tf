
/*
 helm upgrade --install pg-sqlproxy rimusz/gcloud-sqlproxy --namespace sqlproxy \
    --set serviceAccountKey="$(cat service-account.json | base64 | tr -d '\n')" \
    --set cloudsql.instances[0].instance=INSTANCE \
    --set cloudsql.instances[0].project=PROJECT \
    --set cloudsql.instances[0].region=REGION \
    --set cloudsql.instances[0].port=5432 -i
*/

resource "helm_release" "sqlproxy" {
  namespace  = "elizabeth-garcia1epam-com"
  name       = "cloudsql-proxy"
  repository = "https://charts.rimusz.net"
  chart      = "gcloud-sqlproxy"

  values = [
    templatefile("values.yaml", {
      instance = google_sql_database_instance.instance.name
      project  = var.project_id
      region   = "us-central1"
    })
  ]
  set_sensitive {
    name  = "serviceAccountKey"
    value = base64encode(data.google_kms_secret.sql_user_password.plaintext)
  }
  depends_on = [helm_release.ghost]
}