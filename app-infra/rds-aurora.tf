module "kubewpdb" {
  source  = "cloudposse/rds-cluster/aws"
  version = "0.44.1"

  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = "5.7"
  cluster_family = "aurora-mysql5.7"
  cluster_size   = 1
  name           = var.db_name
  admin_user     = "masteruser"
  admin_password = "notsecretpwd9"
  db_name        = var.db_name
  instance_type  = "db.t3.medium"

  vpc_id         = module.vpc.vpc_id
  subnets        = module.vpc.database_subnets

  security_groups = [aws_security_group.eks-security-group.id,
  aws_security_group.kube-wp-sg.id]
}