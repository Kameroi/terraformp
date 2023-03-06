# https://kubernetes.io/docs/concepts/services-networking/ingress/
# target-type: instance for LB/nodeport services, IP for ClusterIP
resource "kubectl_manifest" "default_ingress" {
  yaml_body = <<-EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/load-balancer-name: aws-load-balancer-controller
spec:
  ingressClassName: alb
  rules:
    - http:
        paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              service:
              name: kube-wp
              port:
                number: 8080
EOF
}



/*
resource "kubectl_manifest" "default_ingress" {
  yaml_body = <<-EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    alb.ingress.kubernetes.io/scheme: internal
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/load-balancer-name: aws-load-balancer-controller
    alb.ingress.kubernetes.io/backend-protocol: HTTP
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
spec:
  ingressClassName: alb
  rules:
    - host: example.com
      http:
        paths:
        - pathType: Exact
          path: "/"
          backend:
            service:
              name: kube-wp
              port:
                number: 8080
EOF
}

*/
