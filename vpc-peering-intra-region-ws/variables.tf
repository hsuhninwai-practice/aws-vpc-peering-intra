####### aws region variable
variable "region" {
  description = "The region where the resources are created."
  default     = "ap-southeast-1"
}

variable "profile_accepter" {
  description = "The AWS profile to use for authentication."
  default     = "frontend-network-acc"
}

variable "profile_requester" {
  description = "The AWS profile to use for authentication."
  default     = "backend-network-acc"
}

variable "backend_public_subnet_cidr" {
  description = "The CIDR block for the backend public subnets."
  default     = ["172.22.1.0/24", "172.22.2.0/24", "172.22.3.0/24"]
}

variable "backend_private_subnet_cidr" {
  description = "The CIDR block for the backend private subnets."
  default     = ["172.22.253.0/24", "172.22.254.0/24", "172.22.255.0/24"]
}

variable "frontend_public_subnet_cidr" {
  description = "The CIDR block for the frontend public subnets."
  default     = ["10.7.1.0/24", "10.7.2.0/24", "10.7.3.0/24"]
}

variable "frontend_private_subnet_cidr" {
  description = "The CIDR block for the frontend private subnets."
  default     = ["10.7.253.0/24", "10.7.254.0/24", "10.7.255.0/24"]
}
