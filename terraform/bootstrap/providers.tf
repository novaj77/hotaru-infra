provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = "hotaru"
      Stack     = "bootstrap"
      ManagedBy = "terraform"
    }
  }
}
