aws_region = "ap-south-1"

project_name = "amazona"

environment = "dev"

vpc_cidr = "10.0.0.0/16"

public_subnet_az1_cidr = "10.0.1.0/24"
public_subnet_az2_cidr = "10.0.2.0/24"

private_subnet_az1_cidr = "10.0.3.0/24"
private_subnet_az2_cidr = "10.0.4.0/24"

container_image = "608698601734.dkr.ecr.ap-south-1.amazonaws.com/amazona-backend:latest"

container_port = 4000

cpu = 256

memory = 512

desired_count = 2
