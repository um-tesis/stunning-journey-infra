module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "libera-postgresql"

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t4g.micro"  # # For development purposes. The old values was "db.t4g.large". They were lowered to reduce costs during development. TODO Change to 100 for production.

  allocated_storage     = 7  # For development purposes. The old values was 20. They were lowered to reduce costs during development. TODO Change to 20 for production.
  max_allocated_storage = 7  # For development purposes. The old values was 100. They were lowered to reduce costs during development. TODO Change to 100 for production.

  create_db_option_group = true
  create_db_parameter_group = true
  # create_db_subnet_group is not added because it is already created in the vpc module.

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "liberadbname"
  username = "liberadbusername"
  port     = 5432

  multi_az               = true
  db_subnet_group_name   = module.vpc.database_subnet_group
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 7  # Days
  skip_final_snapshot     = true  # For development purposes, we set it to true. It makes the process faster. TODO Change to false for production.
  deletion_protection     = false  # For development purposes, we set it to false. It makes the process faster.  TODO Change to true for production.

  performance_insights_enabled          = true
  performance_insights_retention_period = 7  # Days
  create_monitoring_role                = true
  monitoring_interval                   = 60  # Seconds
  monitoring_role_name                  = "libera-monitoring-role-name"
  monitoring_role_use_name_prefix       = true
  monitoring_role_description           = "Description for monitoring role"

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]

  tags = {
    Environment = "production"
  }

  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "libera-postgresql"
  description = "Libera PostgreSQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

  tags = {
    Environment = "production"
  }
}
