

resource "google_kms_key_ring" "keyring" {
  project  = var.project_id
  name     = "keyring-sql"
  location = "global"
}

resource "google_kms_crypto_key" "key" {
  name     = "crypto-key"
  key_ring = google_kms_key_ring.keyring.id


  lifecycle {
    prevent_destroy = true
  }
}


data "google_kms_secret" "sql_user_password" {
  crypto_key = google_kms_crypto_key.key.id
  ciphertext = filebase64("SQL-demo2")
}
