provider "aws" {
  region  = var.region
  profile = var.profile_requester
}

provider "aws" {
  alias   = "accepter"
  region  = var.region
  profile = var.profile_accepter
}

provider "aws" {
  alias   = "requester"
  region  = var.region
  profile = var.profile_requester
}