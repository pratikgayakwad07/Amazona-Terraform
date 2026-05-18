resource "aws_ecs_task_definition" "backend" {
  family = "${var.project_name}-${var.environment}-backend"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu = var.cpu

  memory = var.memory

  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name = "backend"

      image = var.container_image

      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

<<<<<<< HEAD
=======
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        },
        {
          name  = "PORT"
          value = tostring(var.container_port)
        },
        {
          name  = "MONGODB_URI"
          value = var.mongo_uri
        },
        {
          name  = "JWT_SECRET"
          value = var.jwt_secret
        },
        {
          name  = "PAYPAL_CLIENT_ID"
          value = var.paypal_client_id
        }
      ]

>>>>>>> 72001be (Rename environment variable MONGO_URI to MONGODB_URI)
      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = "ap-south-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend_service" {
  name = "${var.project_name}-${var.environment}-service"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.backend.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {
    subnets = var.private_subnets

    security_groups = [aws_security_group.ecs_sg.id]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn

    container_name = "backend"

    container_port = var.container_port
  }
}
