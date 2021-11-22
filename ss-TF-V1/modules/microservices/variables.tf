#Resources from other modules
variable "ecs_execution_role" {
    type = string
    description = "ARN of the ecs_execution_role to be assigned to the task definitions"
}

variable "vpc_id" {
    type = string
    description = "ID of the vpc being used"
}

variable "alb_listener" {
    type = string
    description = "ARN of the ALB's listener for the listener rules to be added to"
}

variable "ecs_cluster" {
    type = string
    description = "ID of the ECS Cluster to add the services to"
}

variable "lb_security_groups" {
    type = list(string)
    description = "List of alb security groups"
}

variable "public_subnets" {
    type = list(string)
    description = "List of public subnet ids"
}

variable "private_subnets" {
    type = list(string)
    description = "List of private subnet ids"
}

variable "cloudwatch_log_group" {
    type = string
    description = "cloudwatch log group"
}



#Resources from define
variable "service_name" {
    type = string
    description = "Name of the service"
}

variable "container_port" {
    type = number
    description = "The port that the container exposes"
}

variable "listener_path" {
    type = string
    description = "Path for the load balancer listener"
}

variable "health_check_path" {
    type = string
    description = "Path for the target group's health checks"
}

variable "ecr_repository" {
    type = string
    description = "URL for the ecr repository to pull images from"
}