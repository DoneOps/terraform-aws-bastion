module "bastion_host" {
  source               = "../../"
  name                 = "bastion"
  vpc_id               = data.aws_vpc.default.id
  subnet_id            = data.aws_subnets.default.ids[0]
  bastion_ip_allowlist = ["0.0.0.0/0"]
}
