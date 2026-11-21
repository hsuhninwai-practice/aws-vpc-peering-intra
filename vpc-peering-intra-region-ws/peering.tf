resource "aws_vpc_peering_connection" "fevpc_peering_bevpc" {
  provider      = aws.requester
  vpc_id        = data.terraform_remote_state.frontend_network.outputs.frontend_vpc_id
  peer_vpc_id   = data.terraform_remote_state.backend_network.outputs.backend_vpc_id
  peer_owner_id = data.aws_caller_identity.accepter.account_id
  peer_region   = var.region

  tags = {
    Side = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "fevpc_peering_bevpc" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.fevpc_peering_bevpc.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

resource "aws_route" "fevpc_private_subnet02_to_bevpc_private_subnet02" {
  provider                  = aws.requester
  route_table_id            = data.terraform_remote_state.frontend_network.outputs.frontend_private_rtb02_id
  destination_cidr_block    = var.backend_private_subnet_cidr[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.fevpc_peering_bevpc.id
}

resource "aws_route" "bevpc_private_subnet02_to_fevpc_private_subnet02" {
  provider                  = aws.accepter
  route_table_id            = data.terraform_remote_state.backend_network.outputs.backend_private_rtb02_id
  destination_cidr_block    = var.frontend_private_subnet_cidr[1]
  vpc_peering_connection_id = aws_vpc_peering_connection.fevpc_peering_bevpc.id
}

resource "aws_route" "fevpc_private_subnet03_to_bevpc_private_subnet03" {
  provider                  = aws.requester
  route_table_id            = data.terraform_remote_state.frontend_network.outputs.frontend_private_rtb03_id
  destination_cidr_block    = var.backend_private_subnet_cidr[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.fevpc_peering_bevpc.id
}

resource "aws_route" "bevpc_private_subnet03_to_fevpc_private_subnet03" {
  provider                  = aws.accepter
  route_table_id            = data.terraform_remote_state.backend_network.outputs.backend_private_rtb03_id
  destination_cidr_block    = var.frontend_private_subnet_cidr[2]
  vpc_peering_connection_id = aws_vpc_peering_connection.fevpc_peering_bevpc.id
}