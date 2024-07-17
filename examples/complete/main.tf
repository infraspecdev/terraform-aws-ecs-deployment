provider "aws" {
  region = local.region

  default_tags {
    tags = local.default_tags
  }
}

locals {
  region      = "ap-south-1"
  name_prefix = "ex-"

  # VPC
  vpc_name            = "${local.name_prefix}my-vpc"
  vpc_cidr            = "10.0.0.0/16"
  vpc_azs             = ["ap-south-1a", "ap-south-1b"]
  vpc_private_subnets = ["10.0.1.0/24", "10.0.11.0/24"]
  vpc_public_subnets  = ["10.0.2.0/24", "10.0.12.0/24"]

  # ECS Cluster (pre-configured)
  cluster_name = "${local.name_prefix}my-cluster"

  # ECS Service
  service_name = "${local.name_prefix}my-service"

  # ACM
  base_domain = "example.com" # TODO: Update to your base domain
  endpoint    = "${local.name_prefix}complete"
  ssl_policy  = "ELBSecurityPolicy-2016-08"

  default_tags = {
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

################################################################################
# ECS Deployment Module
################################################################################

module "ecs_deployment" {
  source = "../../"

  task_definition = {
    family       = "${local.name_prefix}nginx"
    network_mode = "awsvpc"

    cpu    = 128
    memory = 256

    container_definitions = [
      {
        name      = "nginx"
        image     = "nginx:latest"
        cpu       = 128
        memory    = 256
        essential = true

        portMappings = [
          {
            name          = "http"
            containerPort = 80
            hostPort      = 80
            protocol      = "tcp"
          }
        ]

        readonlyRootFilesystem = false
      }
    ]
  }

  service = {
    name                 = local.service_name
    cluster              = local.cluster_name
    desired_count        = 1
    force_new_deployment = true

    network_configuration = {
      security_groups = [aws_security_group.allow_nginx_http_from_alb.id]
      subnets         = module.vpc.private_subnets
    }

    load_balancer = [
      {
        target_group_arn = module.alb.target_groups_arns["this"]
        container_name   = "nginx"
        container_port   = 80
      }
    ]
  }
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.9.0"

  name = local.vpc_name
  cidr = local.vpc_cidr

  azs             = local.vpc_azs
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = false
}

data "aws_ami" "ecs_optimized_amzn_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

module "asg" {
  source = "../../modules/asg"

  name                  = "${local.name_prefix}my-asg"
  vpc_zone_identifier   = module.vpc.private_subnets
  protect_from_scale_in = true

  desired_capacity = 1
  min_size         = 1
  max_size         = 1

  launch_template = {
    name                   = "${local.name_prefix}my-launch-template"
    image_id               = data.aws_ami.ecs_optimized_amzn_linux.id
    instance_type          = "t2.micro"
    vpc_security_group_ids = [aws_security_group.allow_all_within_vpc.id]
    user_data              = <<-EOT
      #!/bin/bash
      echo ECS_CLUSTER=${local.cluster_name} >> /etc/ecs/ecs.config
    EOT
  }

  iam_role_ec2_container_service_role_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

module "capacity_provider" {
  source = "../../modules/capacity-provider"

  ecs_cluster_name               = local.cluster_name
  default_auto_scaling_group_arn = module.asg.arn

  capacity_providers = {
    my-capacity-provider = {
      name = "${local.name_prefix}my-capacity-provider"
      managed_scaling = {
        status                    = "ENABLED"
        target_capacity           = 100
        minimum_scaling_step_size = 1
        maximum_scaling_step_size = 1
      }
    }
  }

  default_capacity_provider_strategies = [
    {
      capacity_provider = "my-capacity-provider"
      weight            = 1
      base              = 0
    }
  ]
}

################################################################################
# # Application Load Balancer
################################################################################

module "alb" {
  source = "../../modules/alb"

  name                = "${local.name_prefix}my-alb"
  internal            = false
  security_groups_ids = [aws_security_group.alb_allow_all.id]
  subnets_ids         = module.vpc.public_subnets

  target_groups = {
    this = {
      name        = "${local.name_prefix}my-alb-tg"
      vpc_id      = module.vpc.vpc_id
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"

      health_check = {
        path = "/"
      }
    }
  }

  listeners = {
    this = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = module.acm.amazon_issued_acm_certificates_arns["base_domain"]
      ssl_policy      = local.ssl_policy

      default_action = [
        {
          type         = "forward"
          target_group = "this"
        }
      ]
    }
  }
}

################################################################################
# # ACM
################################################################################

data "aws_route53_zone" "base_domain" {
  name = local.base_domain
}

module "acm" {
  source = "../../modules/acm"

  amazon_issued_certificates = {
    base_domain = {
      domain_name       = local.base_domain
      validation_method = "DNS"
    }
  }
}

resource "aws_route53_record" "endpoint" {
  zone_id = data.aws_route53_zone.base_domain.zone_id
  name    = local.endpoint
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_acm_certificate_validation" "base_domain_certificate" {
  certificate_arn         = module.acm.amazon_issued_acm_certificates_arns["base_domain"]
  validation_record_fqdns = [aws_route53_record.endpoint.fqdn]
}

################################################################################
# # Security Groups
################################################################################

resource "aws_security_group" "allow_all_within_vpc" {
  name        = "${local.name_prefix}allow-all-within-vpc"
  description = "Allow all ingress and egress traffic within the VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_allow_all" {
  name        = "${local.name_prefix}alb-allow-all"
  description = "Allow all ingress and egress traffic within Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_nginx_http_from_alb" {
  name        = "${local.name_prefix}allow-all-from-alb"
  description = "Allow all Nginx HTTP ingress and egress traffic from Load Balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_allow_all.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
