locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name           = "primary"
  creation_token = "primary-token"
  encrypted      = false
  attach_policy                      = true

  # Mount targets / security group
  mount_targets = { for k, v in toset(range(length(local.azs))) :
    element(local.azs, k) => { subnet_id = element(module.vpc.private_subnets, k) }
  }
  security_group_description = "Example EFS security group"
  security_group_vpc_id      = module.vpc.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = module.vpc.private_subnets_cidr_blocks
      #cidr_blocks = module.vpc.database_subnets_cidr_blocks
    }
  }

  enable_backup_policy = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}