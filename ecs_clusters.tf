resource "aws_ecs_cluster" "lab4cluster" {
  name = "lab2"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.ns_lab4.arn
  }
  # terraform import aws_ecs_cluster.lab4cluster lab2
}

resource "aws_service_discovery_http_namespace" "ns_lab4" {
  name = "lab2"
  tags = {
    "AmazonECSManaged" = "true"
  }
  tags_all = {
    "AmazonECSManaged" = "true"
  }

  # terraform import aws_service_discovery_http_namespace.ns_lab4 ns-p7w7h5lxqetf27c3
}

resource "aws_ecs_cluster" "lab4_stresstest" {
  name = "stresstest-lab4-cluster"

  configuration {
    execute_command_configuration {
      logging = "DEFAULT"
    }
  }

  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.ns_stresstest.arn
  }

}

resource "aws_service_discovery_http_namespace" "ns_stresstest" {
  name = "stresstest-lab4"
  tags = {
    "AmazonECSManaged" = "true"
  }
  tags_all = {
    "AmazonECSManaged" = "true"
  }
}

resource "aws_ecs_cluster_capacity_providers" "lab4_stresstest_capacity_provider" {
  cluster_name = aws_ecs_cluster.lab4_stresstest.name

  capacity_providers = [
    aws_ecs_capacity_provider.stresstest_app_lab4_capacity_provider.name,
  ]
}