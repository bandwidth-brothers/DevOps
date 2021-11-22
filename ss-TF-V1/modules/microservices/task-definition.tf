resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  execution_role_arn       = var.ecs_execution_role
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([
      {
          name = var.service_name
          image = var.ecr_repository
          portMappings = [
              {
                  containerPort = var.container_port
              }
          ]
        
            logConfiguration = {
            logDriver = "awslogs"
            options = {
                awslogs-region = "us-east-2"                
                awslogs-stream-prefix = "food-service"
                awslogs-group = var.cloudwatch_log_group
            }
          }
      }
  ])
}

