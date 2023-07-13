variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet in which to dpeloy the ec2 instance"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Region to run Resource"
  type        = string
  default     = "us-east-1"
}

variable "bastion_ip_allowlist" {
  description = "List of IPv4 CIDR blocks which can access the Bastion proxy"
  type        = list(string)
  default     = []
}

variable "name" {
  type        = string
  description = "Stack name to use in resource creation"
}

