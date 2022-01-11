#User
/*resource "google_sql_user" "users" {
  name     = "user-sql"
  instance = google_sql_database_instance.isntance.name
  type     = "CLOUD_IAM_USER"
}*/



##########################################################
/*
module "sql-db" {
  source  = "GoogleCloudPlatform/sql-db/google"
  version = "8.0.0"
  # insert the 5 required variables here
    project_id = var.project_id
    user_name = "user-sql"
    user_password = ""

    database_version = "MYSQL_5_6" #####
    name = "mysql-instance" ############ 
    activation_policy = "ALWAYS" #######

    zone = "us-central1-b" #############
    region = "us-central1" #############
    tier = "db-n1-standard-1" ##########
    db_charset = "UTF8" 
}*/
#########################################################
resource "google_sql_database_instance" "instance" {
  project          = var.project_id
  name             = "mysql-instance"
  region           = "us-central1"
  database_version = "MYSQL_5_6"
  #zone             = "us-central1-b"

  depends_on = [google_compute_network.vpc_network]

  settings {
    tier              = "db-n1-standard-1"
    availability_type = "REGIONAL"
    activation_policy = "ALWAYS"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
    }
    backup_configuration {
      binary_log_enabled = false
    }
  }
}
resource "google_sql_user" "users" {
  name     = "user-sql"
  instance = google_sql_database_instance.instance.name
  host     = "mysql-demodb.com"
  password = ""
}
provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-b"
}

##############################################################
#a.	Regional (same region of the GKE cluster).               #
#b.	Version 5.6.                                             #
#c.	Tier n1-standard-1.                                      #
#d.	Charset UTF8.                                            #
#e.	Activation policy: ALWAYS.                               #
#f.	Set user and password (to be used later).                #
#g.	Use the same network as the GKE cluster.                 #
##############################################################

