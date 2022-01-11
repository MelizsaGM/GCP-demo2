#Stores the state as an object in a configurable prefix in a pre-existing bucket
terraform {
  backend "gcs" {
    bucket = "demo2-gcp"
    prefix = "terraform/environment/dev" //to Identify into bucket
  }
}
