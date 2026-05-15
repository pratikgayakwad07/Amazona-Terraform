resource "aws_security_group" "ecs_sg" {
  name = "${var.project_name}-${var.environment}-ecs-sg"

  vpc_id = var.vpc_id

  ingress {
    from_port = var.container_port

    to_port = var.container_port

    protocol = "tcp"

    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name = "/ecs/${var.project_name}"
}
