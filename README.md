<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.bastion_host_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.bastion_host_ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.allow_bastion_ssh_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazon2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_ip_allowlist"></a> [bastion\_ip\_allowlist](#input\_bastion\_ip\_allowlist) | List of IPv4 CIDR blocks which can access the Bastion proxy | `list(string)` | `[]` | no |
| <a name="input_bastion_sg_id"></a> [bastion\_sg\_id](#input\_bastion\_sg\_id) | ID for existing Bastion SG to add to new bastions | `list(any)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of environment (production, stage, etc.) | `string` | n/a | yes |
| <a name="input_install_bastion"></a> [install\_bastion](#input\_install\_bastion) | Whether or not to install bastion host | `bool` | `false` | no |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | IAM Instance profile for bastion host | `string` | n/a | yes |
| <a name="input_is_production"></a> [is\_production](#input\_is\_production) | True if environment is production - needed for certs | `bool` | `false` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of AWS keypair for host access | `string` | `"instances"` | no |
| <a name="input_name"></a> [name](#input\_name) | Stack name to use in resource creation | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region to run Resource | `string` | `"us-east-1"` | no |
| <a name="input_ssh_public_keys"></a> [ssh\_public\_keys](#input\_ssh\_public\_keys) | List of public ssh keys to allow access from | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet in which to dpeloy the ec2 instance | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_userdata_path"></a> [userdata\_path](#input\_userdata\_path) | Path to userdata template file | `string` | `"../../../modules/aws/bastion-host/cloud-init-users.yml"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_incoming_security_group_id"></a> [incoming\_security\_group\_id](#output\_incoming\_security\_group\_id) | Security group ID for bastion sg |
<!-- END_TF_DOCS -->