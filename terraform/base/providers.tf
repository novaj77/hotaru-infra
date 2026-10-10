provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project   = "hotaru"
      Stack     = "base"
      ManagedBy = "terraform"
    }
  }
}
