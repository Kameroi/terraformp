# https://github.com/bitnami/charts/blob/main/bitnami/wordpress/values.yaml
# https://github.com/bitnami/charts/tree/main/bitnami/wordpress
resource "helm_release" "wordpress" {
  name       = "wordpress"
  description = "Consists Wordpress, MariaDB, Memcached charts"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]
  timeout = 180
/*
  values = [
    file("./values_wp.yaml")
  ]*/
  
  set {
    name  = "wordpressUsername"
    value = "user2"
  }
  
  set {
    name  = "wordpressPasswordd"
    value = "password2"
  }
  
  set {
    name  = "mariadb.auth.rootPassword"
    value = "secretpassword"
  }
}