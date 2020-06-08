module "policies_service-v2" {
  source = "./service-blue-green"
  service_name = "policies-service-v2"
  tags = var.tags
  task_definition = file("${path.module}/policies-service.json")
  ecs_cluster_id = var.ecs_cluster_id
  ecs_cluster_name = var.ecs_cluster_name
  main_container_name = "policies-service-nginx"
  main_container_port = 80
  service_subnet_ids = var.service_subnet_ids
  lb_subnet_ids =  var.loadbalancer_subnet_ids
  vpc_id = var.vpc_id
  desired_count = 0
  service_discovery_namespace_id = aws_service_discovery_private_dns_namespace.mzonjy_ns.id
  codedeploy_service_role_arn = aws_iam_role.ecsCodeDeployRole.arn
}
