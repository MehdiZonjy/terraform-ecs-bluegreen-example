variable "service_name" {
  type = string
}
variable "tags" {
  type = map(string)
}

variable "task_definition" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}
variable "main_container_name" {
  type = string
}
variable "main_container_port" {
  type = number
}
variable "service_subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}

variable "lb_subnet_ids" {
  type = list(string)
}

variable "desired_count" {
  type = number
}

variable "service_discovery_namespace_id" {
  type = string
}

variable "codedeploy_service_role_arn" {
  type = string
}