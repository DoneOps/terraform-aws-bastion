resource "aws_kms_key" "parameter_store_bastion" {
  description             = "Parameter store bastion values - ${var.name}"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true
  tags = {
    Name = "${var.name}-paramstore-bastion"
  }
}

resource "aws_ssm_parameter" "instance_ssh_private_bastion" {
  name   = "SSH_PRIVATE_KEY_INSTANCES"
  type   = "SecureString"
  value  = " "
  key_id = aws_kms_key.parameter_store_bastion.key_id
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

resource "aws_ssm_parameter" "host_ssh_rsa_public_bastion" {
  name   = "SSH_RSA_PUBLIC_KEY_BASTION_HOST"
  type   = "SecureString"
  value  = " "
  key_id = aws_kms_key.parameter_store_bastion.key_id
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

resource "aws_ssm_parameter" "host_ssh_rsa_private_bastion" {
  name   = "SSH_RSA_PRIVATE_KEY_BASTION_HOST"
  type   = "SecureString"
  value  = " "
  key_id = aws_kms_key.parameter_store_bastion.key_id
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

resource "aws_ssm_parameter" "host_ssh_ed25519_public_bastion" {
  name   = "SSH_ED25519_PUBLIC_KEY_BASTION_HOST"
  type   = "SecureString"
  value  = " "
  key_id = aws_kms_key.parameter_store_bastion.key_id
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

resource "aws_ssm_parameter" "host_ssh_ed25519_private_bastion" {
  name   = "SSH_ED25519_PRIVATE_KEY_BASTION_HOST"
  type   = "SecureString"
  value  = " "
  key_id = aws_kms_key.parameter_store_bastion.key_id
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}

resource "aws_iam_policy" "bastion_parameter_store_kms" {
  name = "BastionAccessParameterStoreKMS-${var.region}"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
        ]
        Effect   = "Allow"
        Resource = "${aws_kms_key.parameter_store_bastion.arn}"
      },
    ]
  })
}

resource "aws_iam_policy" "parameter_store_read_keys" {
  name = "BastionAccessParameterStoreParams-${var.region}"
  path = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:DescribeParameters"
        ],
        "Resource" : [
          aws_ssm_parameter.instance_ssh_private_bastion.arn,
          aws_ssm_parameter.host_ssh_rsa_public_bastion.arn,
          aws_ssm_parameter.host_ssh_rsa_private_bastion.arn,
          aws_ssm_parameter.host_ssh_ed25519_public_bastion.arn,
          aws_ssm_parameter.host_ssh_ed25519_private_bastion.arn,
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameter"
        ],
        "Resource" : [
          aws_ssm_parameter.instance_ssh_private_bastion.arn,
          aws_ssm_parameter.host_ssh_rsa_public_bastion.arn,
          aws_ssm_parameter.host_ssh_rsa_private_bastion.arn,
          aws_ssm_parameter.host_ssh_ed25519_public_bastion.arn,
          aws_ssm_parameter.host_ssh_ed25519_private_bastion.arn,
        ]
      },
    ]
  })
}

resource "aws_iam_role" "ec2_role_bastion" {
  name               = "ec2-role-bastion-${var.region}"
  assume_role_policy = data.aws_iam_policy_document.ec2_role_assume_role_bastion_policy.json
  managed_policy_arns = [
    aws_iam_policy.bastion_parameter_store_kms.arn,
    aws_iam_policy.parameter_store_read_keys.arn
  ]
}

data "aws_iam_policy_document" "ec2_role_assume_role_bastion_policy" {
  version = "2008-10-17"
  statement {
    sid     = ""
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "bastion_ec2_instance_profile" {
  name = "bastion-ec2-instance-profile-${var.region}"
  role = aws_iam_role.ec2_role_bastion.name
}
