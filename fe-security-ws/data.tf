data "terraform_remote_state" "frontend_network" {
  backend = "remote"
  config = {
    organization = "CIE_2026"
    workspaces = {
      name = "fe-network-ws"
    }
  }
}

data "terraform_remote_state" "backend_security" {
  backend = "remote"
  config = {
    organization = "CIE_2026"
    workspaces = {
      name = "be-security-ws"
    }
  }
}