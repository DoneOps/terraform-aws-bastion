module "bastion_host" {
  source               = "../../"
  name                 = "foo"
  vpc_id               = data.aws_vpc.default.id
  subnet_id            = data.aws_subnets.default.ids[0]
  bastion_ip_allowlist = ["0.0.0.0/0"]
  ssh_public_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDo6hqDehPPFoOuKlU8Db8RWfJX9It8EGY8Cpj3ICwFr john@doneops.com"
  ]
}
