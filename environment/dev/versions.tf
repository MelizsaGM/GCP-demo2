terraform {
  required_version = ">= 0.13.0"
  required_providers {
    google = { //block that defines providers settings called "google"
      source  = "hashicorp/google"
      version = "< 5.0, >= 2.12" //optional but recommended	
    }
  }
}



