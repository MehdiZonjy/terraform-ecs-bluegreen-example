variable "vpc_id" {
  type = string
}
variable "service_subnet_ids" {
  type = list(string)
}

variable "loadbalancer_subnet_ids" {
  type = list(string)
}

variable "ecs_cluster_id" {
  type = string
}
variable "ecs_cluster_name" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}