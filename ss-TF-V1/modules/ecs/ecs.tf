resource "aws_ecs_cluster" "ecs-cluster-demo" {
  name = "food-del-cluster"
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
      capacity_provider = "FARGATE"
      weight = 1
  }
}

resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.food-alb.id]
  ip_address_type    = "ipv4"
}

resource "aws_security_group" "food-alb" {
  name        = "food-alb-test"
  description = "controls access to the Application Load Balancer (ALB)"
   vpc_id            = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 9090
    cidr_blocks = ["0.0.0.0/0"]
  }

      ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 8020
    cidr_blocks = ["0.0.0.0/0"]
  }

        ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 8010
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "food-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_security_group" "container-sg" {
  vpc_id      = var.vpc_id
  description = "Enable all access from ALBSecurityGroup and Bastion"

  ingress = [
    {
      description      = "Enable all access from ALB SG"
      from_port        = 0
      protocol      = "-1"
      security_groups  = [aws_security_group.food-alb.id]
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      self             = false
      cidr_blocks      = []
  }]

  egress = [
    {
      description      = "Allows all traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    "Name" = "food-container-sg"
  }

}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.default-tg
  }
}


resource "aws_cloudwatch_log_group" "food-log-group" {
  name = "food-log-group"

  tags = {
    Environment = "staging"
    Application = "food-app"
  }
}