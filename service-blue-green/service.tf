
data "aws_iam_policy_document" "task_ecs_assume_role" {
  statement {
    effect = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}


data "aws_iam_policy_document" "service_policy" {
  statement {
    actions = ["s3:List*"]
    resources = ["*"]
  }
}


resource "aws_iam_role" "service_role" {
  assume_role_policy = data.aws_iam_policy_document.task_ecs_assume_role.json
  name = var.service_name
  tags = var.tags
}
resource "aws_iam_role_policy" "service_policy" {
  policy = data.aws_iam_policy_document.service_policy.json
  role = aws_iam_role.service_role.name
}

resource "aws_ecs_task_definition" "service_task" {
  family = var.service_name
  container_definitions = var.task_definition
  network_mode = "awsvpc"
  tags = var.tags
  depends_on = [aws_iam_role.service_role]
  task_role_arn = aws_iam_role.service_role.arn
}

resource "aws_ecs_service" "service" {

  name = var.service_name
  task_definition = aws_ecs_task_definition.service_task.arn
  cluster = var.ecs_cluster_id
  desired_count = var.desired_count
  launch_type = "EC2"
  scheduling_strategy = "REPLICA"
  tags = var.tags


  ordered_placement_strategy {
    type = "binpack"
    field = "memory"
  }

  ordered_placement_strategy {
    type = "binpack"
    field = "cpu"
  }

  ordered_placement_strategy {
    type = "spread"
    field = "attribute:ecs.availability-zone"
  }


  load_balancer {
    target_group_arn = aws_lb_target_group.blue.arn
    container_name = var.main_container_name
    container_port = var.main_container_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }


  network_configuration {
    subnets = var.service_subnet_ids
    assign_public_ip = false
    security_groups = [aws_security_group.service.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.service.arn
    port = var.main_container_port
  }
  lifecycle {
    ignore_changes = [
//      task_definition,
//      load_balancer,
//      network_configuration,
//      network_configuration[0],
//      "task_definition",
//      "load_balancer",
//      "network_configuration",
//      "network_configuration[0]"
    ]
  }
}



resource "aws_security_group" "service" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
//    security_groups = [aws_security_group.lb_service.id]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

