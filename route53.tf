resource "aws_service_discovery_private_dns_namespace" "mzonjy_ns" {
  name        = "mzonjy.local"
  description = "mzonjy service discovery"
  vpc         = var.vpc_id
}

