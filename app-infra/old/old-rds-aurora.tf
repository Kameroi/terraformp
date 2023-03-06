module "aurora-cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  master_username = "masteruser"
  create_random_password = false
  master_password = "notsecretpwd9"

  name           = var.db_name
  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  port = 3306
  engine_version = "5.7"
  instance_class = "db.t3.medium"
  instances = { # 1 writer, 2 readers
    one   = {
      #instance_class = "db.t3.medium"
    }
    two   = {
      #instance_class = "db.t3.small"
    }
    three = {
      #instance_class = "db.t3.small"
    }
  }

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.database_subnets

  allowed_cidr_blocks    = module.vpc.private_subnets_cidr_blocks

  allowed_security_groups = [aws_security_group.eks-security-group.id,
  aws_security_group.kube-wp-sg.id]

  storage_encrypted   = false
  apply_immediately   = true

  db_parameter_group_name         = "default.aurora-mysql5.7"
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"
}