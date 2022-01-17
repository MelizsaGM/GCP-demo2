resource "kubernetes_cron_job" "demo" {
  metadata {
    namespace = "elizabeth-garcia1epam-com"
    name      = "kronjob-sql"
  }
  spec {
    concurrency_policy            = "Replace"
    failed_jobs_history_limit     = 5
    schedule                      = "@daily"
    starting_deadline_seconds     = 10
    successful_jobs_history_limit = 10
    job_template {
      metadata {}
      spec {
        backoff_limit              = 2
        ttl_seconds_after_finished = 10
        template {
          metadata {}
          spec {
            automount_service_account_token = true
            service_account_name = "cron-sql"
            container {
              
              name               = "sql-demo"
              image              = "us.gcr.io/gcpdemo-task1/cronsql@sha256:9b9b076db233357649eab03035652b086d6c323f97a1e3b2814580b4730ed33b"
              command            = ["/bin/ash", "-c", "date; gsutil ls; export MYSQL_PWD=${sha256(random_string.password.result)}; mysqldump -u db-demo-user -h cloudsql-proxy-gcloud-sqlproxy gcp-training >> /tmp/data-dump.sql && gsutil cp /tmp/data-dump.sql gs://demo2-gcp/gcp-training.gz"]#, "gsutil cp /text.txt gs://demo2-gcp"]
            }
            restart_policy = "Never"
          }
        }
      }
    }
  }
  depends_on = [helm_release.ghost]
}
/*"mysqldump -u ${var.dbuser} -p gcp-training > /backupsql/data-dump.sql", "gsutil cp /backupsql/data-dump.sql gs://demo2-gcp"] ${sha256(bcrypt(random_string.password.result))}
*/