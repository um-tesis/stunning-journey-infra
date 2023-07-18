resource "kubectl_manifest" "namespace" {
  yaml_body = <<-EOF
apiVersion: v1
kind: Namespace
metadata:
  labels:
    app: main-project
  name: main-project
EOF
}

module "s3_access_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.17.0"

  role_name                      = "s3-access"

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["main-project:s3-access"]
    }
  }
}

resource "kubectl_manifest" "service_account_s3" {
  yaml_body = <<-EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: s3-access
  namespace: main-project
  annotations:
    eks.amazonaws.com/role-arn: ${module.s3_access_irsa_role.iam_role_arn}
EOF
}

resource "aws_iam_policy" "s3_policy" {
  name        = "S3AccessPolicy"
  description = "Allow S3 operations"
  
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.libera_s3_bucket.arn}",
        "${aws_s3_bucket.libera_s3_bucket.arn}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  role       = module.s3_access_irsa_role.iam_role_name
  policy_arn = aws_iam_policy.s3_policy.arn
}
