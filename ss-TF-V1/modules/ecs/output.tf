output "alb_listener" {
    value = aws_lb_listener.alb_listener.arn
}

output "ecs_execution_role" {
    value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_cluster" {
    value = aws_ecs_cluster.ecs-cluster-demo.id
}

output "lb_security_groups" {
    value = [aws_security_group.container-sg.id]
}

output "cloudwatch_log_group" {
    value = aws_cloudwatch_log_group.food-log-group.id
}