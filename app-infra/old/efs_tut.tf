module "efs" {
  source  = "cloudposse/efs/aws"
  version = "0.32.0"

  namespace = "kube-wp"
  name      = "wp-content"
  region    = var.region
  vpc_id    = module.vpc.vpc_id
  subnets   = module.vpc.private_subnets

  additional_security_group_rules = [
    {
      type                     = "ingress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "tcp"
      cidr_blocks              = ["10.0.0.0/16"]
      description              = "Allow all traffic from within the VPC"
    },
    {
      type                     = "egress"
      from_port                = 0
      to_port                  = 65535
      protocol                 = "tcp"
      cidr_blocks              = ["0.0.0.0/0"]
      description              = "Allow all outbound traffic"
    }
  ]
}
