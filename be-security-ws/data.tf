data "terraform_remote_state" "backend_network" {
  backend = "remote"
  config = {
    organization = "CIE_2026"
    workspaces = {
      name = "be-network-ws"
    }
  }
}

data "terraform_remote_state" "frontend_security" {
  backend = "remote"
  config = {
    organization = "CIE_2026"
    workspaces = {
      name = "fe-security-ws"
    }
  }
}