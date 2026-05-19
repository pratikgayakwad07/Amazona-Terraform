# Terraform configuration for AWS infrastructure
## VPC module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-${var.environment}-vpc"

  cidr = var.vpc_cidr

  azs = [
    "${var.aws_region}a",
    "${var.aws_region}b"
  ]

  public_subnets = [
    var.public_subnet_az1_cidr,
    var.public_subnet_az2_cidr
  ]

  private_subnets = [
    var.private_subnet_az1_cidr,
    var.private_subnet_az2_cidr
  ]

  enable_nat_gateway = true

  single_nat_gateway = true

  enable_dns_hostnames = true

  enable_dns_support = true
}


## ECR module
module "ecr" {
  source = "./backend/ecr"

  project_name = var.project_name

  environment = var.environment
}


### IAM module
module "iam" {
  source = "./backend/iam"

  project_name = var.project_name

  environment = var.environment
}


## ALB module
module "alb" {
  source = "./backend/alb"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.vpc.vpc_id

  public_subnets = module.vpc.public_subnets

  container_port = var.container_port
}


## ECS module
module "ecs" {
  source = "./backend/ecs"

  project_name = var.project_name

  environment = var.environment

  private_subnets = module.vpc.private_subnets

  container_image = var.container_image

  container_port = var.container_port

  cpu = var.cpu

  memory = var.memory

  desired_count = var.desired_count

  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn

  target_group_arn = module.alb.target_group_arn

  alb_sg_id = module.alb.alb_sg_id

  vpc_id = module.vpc.vpc_id

  mongodb_uri        = var.mongodb_uri

  jwt_secret       = var.jwt_secret

  paypal_client_id = var.paypal_client_id
}


## Frontend module
module "frontend" {
  source = "./frontend"

  project_name = var.project_name

  environment = var.environment

  alb_dns_name = module.alb.alb_dns_name

}
