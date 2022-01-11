/*resource "google_sql_database" "database" {
  name     = "demo-database"
  instance = google_sql_database_instance.instance.name
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta
  project          = var.project_id
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

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
      binary_log_enabled = true
      enabled = true
    }
  }
}
resource "google_sql_user" "users" {
  name     = "user-sql"
  instance = google_sql_database_instance.instance.name
  type     = "CLOUD_IAM_USER"
  host     = "mysql-demodb.com"
  password = ""
}*/

##############################################################
#a.	Regional (same region of the GKE cluster).               #
#b.	Version 5.6.                                             #
#c.	Tier n1-standard-1.                                      #
#d.	Charset UTF8.                                            #
#e.	Activation policy: ALWAYS.                               #
#f.	Set user and password (to be used later).                #
#g.	Use the same network as the GKE cluster.                 #
##############################################################

resource "google_sql_database" "database" {
  project = var.project_id
  name     = "gcp-training"
  instance = google_sql_database_instance.instance.name
}

resource "google_compute_network" "private_network" {
  provider = google-beta
  project = var.project_id
  name = "private-network"
}

#google_compute_network" "vpc_network

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta
  project = var.project_id
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  provider = google-beta
  project = var.project_id

  name             = "test2-instance-${random_id.db_name_suffix.hex}"
  region           = "us-central1"
  database_version = "MYSQL_5_6"
  deletion_protection = false
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-n1-standard-1"
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
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

resource "google_sql_user" "users" {
  name     = "db-demo-user"
  instance = "${google_sql_database_instance.instance.name}"
  host     = "sql-db-demo.com"
  #password = "changeme"
}