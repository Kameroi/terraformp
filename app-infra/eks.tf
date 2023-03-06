module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.25"
  cluster_endpoint_private_access = true  # allows our private endpoints to connect and join cluster
  cluster_endpoint_public_access  = true
  cluster_additional_security_group_ids = [aws_security_group.eks-security-group.id]
  #aws_security_group.efs-security-group.id]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  
  enable_irsa = true

  eks_managed_node_group_defaults = {
    instance_types         = ["t3.small"]
    capacity_type = "SPOT"

    vpc_security_group_ids = [aws_security_group.eks-security-group.id]
  }
  
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"
      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}
