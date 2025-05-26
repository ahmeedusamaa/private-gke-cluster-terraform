terraform {
  backend "gcs" {
    bucket  = "tera_state"
    prefix  = "terraform/state"
  }
}
