resource "aws_codedeploy_app" "service" {
  name = var.service_name
  compute_platform = "ECS"
}

# due to eventually consistency, sometimes codedeploy can't find ECS Service, we need to use resource_null and sleep trick
resource "aws_codedeploy_deployment_group" "service" {
  app_name = aws_codedeploy_app.service.name
  deployment_group_name = var.service_name
  deployment_config_name = "CodeDeployDefault.ECSLinear10PercentEvery1Minutes"
  service_role_arn = var.codedeploy_service_role_arn

  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
  }
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

  }
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.service.arn]
      }
      target_group {
        name = aws_lb_target_group.blue.name
      }

      target_group {
        name = aws_lb_target_group.green.name
      }
    }
  }
}