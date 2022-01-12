/*
resource "google_sql_user" "users" {
  name     = "user-sql"
  instance = google_sql_database_instance.instance.name
  type     = "CLOUD_IAM_USER"
  host     = "mysql-demodb.com"
  password = ""
}*/

##############################################################
#a.	Regional (same region of the GKE cluster).               #
#b.	Version 5.6.           --------------------------------- #
#c.	Tier n1-standard-1.    --------------------------------- #
#d.	Charset UTF8.          --------------------------------- #
#e.	Activation policy: ALWAYS.-------------------------------#
#f.	Set user and password (to be used later).-----1/2        #
#g.	Use the same network as the GKE cluster. ----------------#
##############################################################

resource "google_sql_database" "database" {
  project  = var.project_id
  name     = "gcp-training"
  instance = google_sql_database_instance.instance.name
  charset  = "UTF8"
}

resource "google_compute_global_address" "private_ip_address" {
  provider      = google-beta
  project       = var.project_id
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider                = google-beta
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta
  project  = var.project_id

  name                = "test6-instance-${random_id.db_name_suffix.hex}"
  region              = "us-central1"
  database_version    = "MYSQL_5_6"
  deletion_protection = false
  depends_on          = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = "db-n1-standard-1"
    activation_policy = "ALWAYS"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.id
    }
  }
}

provider "google-beta" {
  region = "us-central1"
  zone   = "us-central1-a"
}

/*resource "google_sql_user" "users" {
  project = var.project_id
  name     = var.dbuser
  instance = "${google_sql_database_instance.instance.name}"
  host     = "sql-db-demo.com"
  #password = "changeme"
}


/**/
resource "random_string" "password" {
  length  = 16
  special = true
}

resource "google_sql_user" "users" {
  project  = var.project_id
  name     = var.dbuser
  host     = "sql-db-demo.com"
  instance = google_sql_database_instance.instance.name
  password = sha256(bcrypt(random_string.password.result))
  lifecycle {
    ignore_changes = ["password"]
  }
  depends_on = [google_sql_database_instance.instance, random_string.password]
}