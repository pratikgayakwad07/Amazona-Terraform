output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.ecs.ecs_service_name
}

output "frontend_bucket_name" {
  value = module.frontend.frontend_bucket_name
}

output "cloudfront_domain_name" {
  value = module.frontend.cloudfront_domain_name
}