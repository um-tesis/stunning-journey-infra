data "aws_caller_identity" "current" {}

provider "aws" {
  profile = "fer-libera"  # Create this profile in your environment with aws configure --profile (region = us-east-1 & output = json)
  region = "us-west-2"
  alias  = "replica"
}

module "kms" {
  source      = "terraform-aws-modules/kms/aws"
  version     = "~> 1.0"
  description = "KMS key for cross region automated backups replication"

  # Aliases
  aliases                 = ["libera-postgresql"]
  aliases_use_name_prefix = true

  key_owners = [data.aws_caller_identity.current.arn]

  tags = {
    Environment = "production"
  }

  providers = {
    aws = aws.replica
  }
}

# ver la diferencia entre esto y el module
# resource "aws_kms_key" "default" {
#   description = "KMS key for cross region automated backups replication"

#   provider = "aws.replica"

#   tags = {
#     Environment = "production"
#   }
# }

resource "aws_db_instance_automated_backups_replication" "default" {
  source_db_instance_arn = module.db.db_instance_arn
  kms_key_id             = module.kms.key_arn  # aws_kms_key.default.arn
  retention_period       = 14

  provider = aws.replica
}
