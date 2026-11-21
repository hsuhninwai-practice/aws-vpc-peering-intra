variable "region" {
  description = "The region where the resources are created."
  default     = "ap-southeast-1"
}

variable "profile" {
  description = "The AWS profile to use for authentication."
  type       = string
  default     = "backend-network-acc"
}

#############################################################
# Backend VPC Variables
#############################################################

variable "backend_vpc_address_space" {
  description = "The CIDR block for the backend VPC."
  default     = "172.22.0.0/16"
}

variable "backend_prefix" {
  description = "The prefix for the backend resources."
  default     = "backend"
}

variable "backend_environment" {
  description = "The environment for the backend resources."
  default     = "dev"
}

variable "backend_public_subnet_cidr" {
  description = "The CIDR block for the backend public subnets."
  default     = ["172.22.1.0/24", "172.22.2.0/24", "172.22.3.0/24"]
}

variable "backend_private_subnet_cidr" {
  description = "The CIDR block for the backend private subnets."
  default     = ["172.22.253.0/24", "172.22.254.0/24", "172.22.255.0/24"]
}

variable "be_instance_type" {
  description = "Specifies the AWS instance type."
  default     = "t3.micro"
}