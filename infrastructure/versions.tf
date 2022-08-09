terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "2.24"
    }
    credstash = {
      source = "terraform-mars/credstash"
      version = "0.5.1"
    }
    google = {
      source = "hashicorp/google"
      version = "3.17.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "3.17.0"
    }
    random = {
      source = "hashicorp/random"
      version = "2.2"
    }
  }
  required_version = ">= 0.13"
}
