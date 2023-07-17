locals {
  region           = data.aws_region.current.name
  account_id       = data.aws_caller_identity.current.account_id
  param_store_path = "/BASTION_HOST/${var.name}"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_id" {
  type        = string
  description = "Subnet in which to dpeloy the ec2 instance"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "bastion_ip_allowlist" {
  type        = list(string)
  description = "List of IPv4 CIDR blocks which can access the Bastion proxy"
  default     = []
}

variable "name" {
  type        = string
  description = "Stack name to use in resource creation"
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "List of public keys to add during build-time"
}
