locals {
  # IAM Instance Profile
  iam_role_ec2_container_service_role_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

  # ACM
  acm_certificates_arns = var.create_acm ? merge(
    try(module.acm[0].amazon_issued_acm_certificates_arns, {}),
    try(module.acm[0].imported_acm_certificates_arns, {}),
    try(module.acm[0].private_ca_issued_acm_certificates_arns, {})
  ) : {}
}

################################################################################
# ECS Service
################################################################################

resource "aws_ecs_service" "this" {
  name    = var.service.name
  cluster = var.cluster_name

  deployment_maximum_percent         = try(var.service.deployment_maximum_percent, null)
  deployment_minimum_healthy_percent = try(var.service.deployment_minimum_healthy_percent, null)
  desired_count                      = try(var.service.desired_count, null)
  enable_ecs_managed_tags            = try(var.service.enable_ecs_managed_tags, true)
  enable_execute_command             = try(var.service.enable_execute_command, null)
  force_new_deployment               = try(var.service.force_new_deployment, null)
  health_check_grace_period_seconds  = try(var.service.health_check_grace_period_seconds, null)
  iam_role                           = try(var.service.iam_role, null)
  launch_type                        = "EC2"
  propagate_tags                     = try(var.service.propagate_tags, null)
  scheduling_strategy                = try(var.service.scheduling_strategy, null)
  task_definition                    = aws_ecs_task_definition.this.id
  triggers                           = try(var.service.triggers, null)
  wait_for_steady_state              = try(var.service.wait_for_steady_state, null)

  dynamic "load_balancer" {
    for_each = try(var.service.load_balancer, [])
    iterator = load_balancer

    content {
      elb_name = try(load_balancer.value.elb_name, null)
      target_group_arn = lookup(
        module.alb[0].target_groups_arns,
        try(load_balancer.value.target_group, null),
        null
      ) != null ? module.alb[0].target_groups_arns[try(load_balancer.value.target_group, null)] : try(load_balancer.value.target_group_arn, null)
      container_name = load_balancer.value.container_name
      container_port = load_balancer.value.container_port
    }
  }

  dynamic "network_configuration" {
    for_each = length(try(var.service.network_configuration, {})) > 0 ? [1] : []

    content {
      subnets          = var.service.network_configuration.subnets
      security_groups  = try(var.service.network_configuration.security_groups, [])
      assign_public_ip = try(var.service.network_configuration.assign_public_ip, false)
    }
  }

  dynamic "service_connect_configuration" {
    for_each = length(try(var.service.service_connect_configuration, {})) > 0 ? [1] : []

    content {
      enabled   = var.service.service_connect_configuration.enabled
      namespace = try(var.service.service_connect_configuration.namespace, null)

      dynamic "log_configuration" {
        for_each = length(try(var.service.service_connect_configuration.log_configuration, {})) > 0 ? [1] : []

        content {
          log_driver = var.service.service_connect_configuration.log_configuration.log_driver
          options    = try(var.service.service_connect_configuration.log_configuration.options, null)

          dynamic "secret_option" {
            for_each = try(var.service.service_connect_configuration.log_configuration.secret_option, [])
            iterator = secret_option

            content {
              name       = secret_option.value.name
              value_from = secret_option.value.value_from
            }
          }
        }
      }

      dynamic "service" {
        for_each = try(var.service.service_connect_configuration.service, [])
        iterator = service

        content {
          port_name             = service.value.port_name
          discovery_name        = try(service.value.discovery_name, null)
          ingress_port_override = try(service.value.ingress_port_override, null)

          dynamic "client_alias" {
            for_each = length(try(service.client_alias, {})) > 0 ? [1] : []

            content {
              port     = service.client_alias.port
              dns_name = try(service.client_alias.dns_name, null)
            }
          }

          dynamic "timeout" {
            for_each = length(try(service.value.timeout, {})) > 0 ? [1] : []

            content {
              idle_timeout_seconds        = try(service.value.timeout.idle_timeout_seconds, null)
              per_request_timeout_seconds = try(service.value.timeout.per_request_timeout_seconds, null)
            }
          }

          dynamic "tls" {
            for_each = length(try(service.value.tls, {})) > 0 ? [1] : []

            content {
              kms_key  = try(service.value.tls.kms_key, null)
              role_arn = try(service.value.tls.role_arn, null)

              issuer_cert_authority {
                aws_pca_authority_arn = try(service.value.tls.issuer_cert_authority.aws_pca_authority_arn, null)
              }
            }
          }
        }
      }
    }
  }

  dynamic "volume_configuration" {
    for_each = length(try(var.service.volume_configuration, {})) > 0 ? [1] : []

    content {
      name = var.service.volume_configuration.name

      managed_ebs_volume {
        role_arn         = var.service.volume_configuration.managed_ebs_volume.role_arn
        encrypted        = try(var.service.volume_configuration.managed_ebs_volume.encrypted, null)
        file_system_type = try(var.service.volume_configuration.managed_ebs_volume.file_system_type, null)
        iops             = try(var.service.volume_configuration.managed_ebs_volume.iops, null)
        kms_key_id       = try(var.service.volume_configuration.managed_ebs_volume.kms_key_id, null)
        size_in_gb       = try(var.service.volume_configuration.managed_ebs_volume.size_in_gb, null)
        snapshot_id      = try(var.service.volume_configuration.managed_ebs_volume.snapshot_id, null)
        throughput       = try(var.service.volume_configuration.managed_ebs_volume.throughput, null)
        volume_type      = try(var.service.volume_configuration.managed_ebs_volume.volume_type, null)
      }
    }
  }

  tags = try(var.service.tags, {})
}

################################################################################
# ECS Task Definition
################################################################################

resource "aws_ecs_task_definition" "this" {
  container_definitions = jsonencode(var.task_definition.container_definitions)
  family                = try(var.task_definition.family, null)

  cpu                      = try(var.task_definition.cpu, null)
  execution_role_arn       = try(var.task_definition.execution_role_arn, null)
  ipc_mode                 = try(var.task_definition.ipc_mode, null)
  memory                   = try(var.task_definition.memory, null)
  network_mode             = try(var.task_definition.network_mode, null)
  pid_mode                 = try(var.task_definition.pid_mode, null)
  requires_compatibilities = ["EC2"]
  skip_destroy             = try(var.task_definition.skip_destroy, null)
  task_role_arn            = try(var.task_definition.task_role_arn, null)
  track_latest             = try(var.task_definition.track_latest, null)

  dynamic "inference_accelerator" {
    for_each = try(var.task_definition.inference_accelerator, [])
    iterator = inference_accelerator

    content {
      device_name = inference_accelerator.value.device_name
      device_type = inference_accelerator.value.device_type
    }
  }

  dynamic "runtime_platform" {
    for_each = length(try(var.task_definition.runtime_platform, {})) > 0 ? [1] : []

    content {
      operating_system_family = try(var.task_definition.runtime_platform.operating_system_family, null)
      cpu_architecture        = try(var.task_definition.runtime_platform.cpu_architecture, null)
    }
  }

  dynamic "placement_constraints" {
    for_each = try(var.task_definition.placement_constraints, [])
    iterator = placement_constraints

    content {
      expression = try(placement_constraints.value.expression, null)
      type       = placement_constraints.value.type
    }
  }

  dynamic "proxy_configuration" {
    for_each = length(try(var.task_definition.proxy_configuration, {})) > 0 ? [1] : []

    content {
      container_name = var.task_definition.proxy_configuration.container_name
      properties     = var.task_definition.proxy_configuration.properties
      type           = try(var.task_definition.proxy_configuration.type, null)
    }
  }

  dynamic "ephemeral_storage" {
    for_each = length(try(var.task_definition.ephemeral_storage, {})) > 0 ? [1] : []

    content {
      size_in_gib = var.task_definition.ephemeral_storage.size_in_gib
    }
  }

  dynamic "volume" {
    for_each = try(var.task_definition.volume, [])
    iterator = volume

    content {
      name                = volume.value.name
      configure_at_launch = try(volume.value.configure_at_launch, null)
      host_path           = try(volume.value.host_path, null)

      dynamic "docker_volume_configuration" {
        for_each = length(try(volume.value.docker_volume_configuration, {})) > 0 ? [1] : []

        content {
          autoprovision = try(volume.value.docker_volume_configuration.autoprovision, null)
          driver_opts   = try(volume.value.docker_volume_configuration.driver_opts, null)
          driver        = try(volume.value.docker_volume_configuration.driver, null)
          labels        = try(volume.value.docker_volume_configuration.labels, null)
          scope         = try(volume.value.docker_volume_configuration.scope, null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = length(try(volume.value.efs_volume_configuration, {})) > 0 ? [1] : []

        content {
          file_system_id          = volume.value.efs_volume_configuration.file_system_id
          root_directory          = try(volume.value.efs_volume_configuration.root_directory, null)
          transit_encryption      = try(volume.value.efs_volume_configuration.transit_encryption, null)
          transit_encryption_port = try(volume.value.efs_volume_configuration.transit_encryption_port, null)

          dynamic "authorization_config" {
            for_each = length(try(volume.value.efs_volume_configuration.authorization_config, {})) > 0 ? [1] : []

            content {
              access_point_id = try(volume.value.efs_volume_configuration.authorization_config.access_point_id, null)
              iam             = try(volume.value.efs_volume_configuration.authorization_config.iam, null)
            }
          }
        }
      }

      dynamic "fsx_windows_file_server_volume_configuration" {
        for_each = length(try(volume.value.fsx_windows_file_server_volume_configuration, {})) > 0 ? [1] : []

        content {
          file_system_id = volume.value.fsx_windows_file_server_volume_configuration.file_system_id
          root_directory = volume.value.fsx_windows_file_server_volume_configuration.root_directory

          authorization_config {
            credentials_parameter = volume.value.fsx_windows_file_server_volume_configuration.credentials_parameter
            domain                = volume.value.fsx_windows_file_server_volume_configuration.domain
          }
        }
      }
    }
  }

  tags = try(var.task_definition.tags, {})
}

################################################################################
# Autoscaling Group Sub-module
################################################################################

module "asg" {
  source = "./modules/asg"

  count = var.create_autoscaling_group ? 1 : 0

  name                = try(var.autoscaling_group.name, null)
  vpc_zone_identifier = try(var.autoscaling_group.vpc_zone_identifier, [])

  desired_capacity      = try(var.autoscaling_group.desired_capacity, null)
  min_size              = try(var.autoscaling_group.min_size, null)
  max_size              = try(var.autoscaling_group.max_size, null)
  protect_from_scale_in = try(var.autoscaling_group.protect_from_scale_in, null)

  # Launch Template
  create_launch_template = try(var.autoscaling_group.create_launch_template, true)
  launch_template_id     = try(var.autoscaling_group.launch_template_id, null)
  launch_template        = try(var.autoscaling_group.launch_template, {})

  # IAM Instance Profile
  create_iam_role                         = try(var.autoscaling_group.create_iam_role, true)
  iam_role_name                           = try(var.autoscaling_group.iam_role_name, null)
  iam_role_tags                           = try(var.autoscaling_group.iam_role_tags, {})
  iam_role_ec2_container_service_role_arn = try(var.autoscaling_group.iam_role_ec2_container_service_role_arn, local.iam_role_ec2_container_service_role_arn)
  create_iam_instance_profile             = try(var.autoscaling_group.create_iam_instance_profile, true)
  iam_instance_profile_name               = try(var.autoscaling_group.iam_instance_profile_name, null)
  iam_instance_profile_tags               = try(var.autoscaling_group.iam_instance_profile_tags, {})

  instances_tags = try(var.autoscaling_group.instances_tags, {})
  tags           = try(var.autoscaling_group.tags, {})
}

################################################################################
# Capacity Provider Sub-module
################################################################################

module "capacity_provider" {
  source = "./modules/capacity-provider"

  count = var.create_capacity_provider ? 1 : 0

  ecs_cluster_name               = var.cluster_name
  default_auto_scaling_group_arn = var.create_autoscaling_group ? module.asg[0].arn : var.capacity_provider_default_auto_scaling_group_arn

  capacity_providers                   = var.capacity_providers
  default_capacity_provider_strategies = var.default_capacity_providers_strategies
}

################################################################################
# Application Load Balancer Sub-module
################################################################################

module "alb" {
  source = "./modules/alb"

  count = var.create_alb ? 1 : 0

  name                       = try(var.load_balancer.name, null)
  internal                   = try(var.load_balancer.internal, null)
  subnets_ids                = try(var.load_balancer.subnets_ids, [])
  security_groups_ids        = try(var.load_balancer.security_groups_ids, [])
  preserve_host_header       = try(var.load_balancer.preserve_host_header, null)
  enable_deletion_protection = try(var.load_balancer.enable_deletion_protection, null)

  target_groups = {
    for k, v in try(var.load_balancer.target_groups, {}) :
    k => merge({
      vpc_id = var.vpc_id
    }, v)
  }

  listeners = {
    for k, v in try(var.load_balancer.listeners, {}) :
    k => merge(
      {
        certificate     = lookup(v, "certificate", null) != null ? v.certificate : null,
        certificate_arn = lookup(v, "certificate_arn", null) != null ? v.certificate_arn : null,
      },
      {
        certificate_arn = lookup(local.acm_certificates_arns, v.certificate, null) != null ? local.acm_certificates_arns[v.certificate] : v.certificate_arn
      },
      v
    )
  }

  tags = try(var.load_balancer.tags, {})
}

################################################################################
# Amazon Certificates Manager Sub-module
################################################################################

module "acm" {
  source = "./modules/acm"

  count = var.create_acm ? 1 : 0

  amazon_issued_certificates     = try(var.acm_amazon_issued_certificates, {})
  imported_certificates          = try(var.acm_imported_certificates, {})
  private_ca_issued_certificates = try(var.acm_private_ca_issued_certificates, {})
}
