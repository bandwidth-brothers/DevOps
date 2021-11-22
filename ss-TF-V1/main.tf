provider "aws" {
  region  = "us-east-2"
  access_key = 
  secret_key = 
}

module "vpc" {
    source = "./modules/vpc"
    vpc_cidr_block = "10.0.0.0/16"
    vpc_tag = "ss-vpc"
}

module "ecs" {
  source = "./modules/ecs"
  default-tg = module.auth-services.default-tg

  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
}

module "auth-services" {
  source = "./modules/microservices"

  service_name = "scrumptious-auth-service"
  container_port = 8000
  listener_path = "/auth/*"
  health_check_path = "/auth/health"
  ecr_repository = "419106922284.dkr.ecr.us-east-2.amazonaws.com/auth-service-john:latest"

  ecs_cluster = module.ecs.ecs_cluster
  ecs_execution_role = module.ecs.ecs_execution_role  
  alb_listener = module.ecs.alb_listener
  lb_security_groups = module.ecs.lb_security_groups
  cloudwatch_log_group = module.ecs.cloudwatch_log_group

  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.public_subnets
}

module "customer-services" {
  source = "./modules/microservices"

  service_name = "customer-service"
  container_port = 8020
  listener_path = "/customers**"
  health_check_path = "/customers/health"
  ecr_repository = "419106922284.dkr.ecr.us-east-2.amazonaws.com/customer-service-john:latest"

  ecs_cluster = module.ecs.ecs_cluster
  ecs_execution_role = module.ecs.ecs_execution_role  
  alb_listener = module.ecs.alb_listener
  lb_security_groups = module.ecs.lb_security_groups
  cloudwatch_log_group = module.ecs.cloudwatch_log_group

  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.public_subnets
  
}

