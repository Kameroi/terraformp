module "aws_load_balancer_controller_irsa_role" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name   = "aws-load-balancer-controller"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.state.outputs.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "service-account-alb" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      #"eks.amazonaws.com/role-arn" = module.vpc_cni_irsa.iam_role_arn
      "eks.amazonaws.com/role-arn" = module.aws_load_balancer_controller_irsa_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}
#########################
#EFS
#########################

module "efs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "efs-csi-controller-sa"
  attach_efs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.state.outputs.oidc_provider_arn
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa"]
    }
  }
}

resource "kubernetes_service_account" "service-account-efs" {
  metadata {
    name = "efs-csi-controller-sa"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "efs-csi-controller-sa"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.efs_csi_irsa_role.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

