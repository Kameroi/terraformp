# IRSA
# https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-role-for-service-accounts-eks
module "vpc_cni_irsa" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  role_name   = "aws-load-balancer-controller"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.eks.outputs.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
      # Remember the namespace_service_accounts line, it is assuming you are 
      # going to create a service account in the kube-system namespace called 
      # aws-load-balancer-controller. 
      # Thats the default location that is used in the documentation. 
      # If you need to use a different namespace or service account name then 
      # thats fine but remember to update this module.
    }
  }
}

# kubernetes_service_account
# A service account provides an identity for processes that run in a Pod. 
# This data source reads the service account and makes specific attributes available to Terraform.
resource "kubernetes_service_account" "service-account" {
  metadata {
    name = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
        "app.kubernetes.io/name"= "aws-load-balancer-controller"
        "app.kubernetes.io/component"= "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = module.vpc_cni_irsa.iam_role_arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}