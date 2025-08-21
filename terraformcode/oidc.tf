provider "aws" {
  region = "us-east-1"
}

# --- OIDC provider for GitHub Actions ---
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub Actions OIDC root cert
}

# --- IAM Role for GitHub Actions ---
resource "aws_iam_role" "github_redshift_role" {
  name = "GitHubRedshiftOIDCRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:<YOUR_ORG>/<YOUR_REPO>:ref:refs/heads/*"
          }
        }
      }
    ]
  })
}

# --- IAM Policy allowing Redshift access ---
resource "aws_iam_policy" "redshift_access" {
  name        = "GitHubRedshiftAccess"
  description = "Allow GitHub Actions to connect to Redshift"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "redshift:GetClusterCredentials",
          "redshift:DescribeClusters",
          "redshift-data:ExecuteStatement",
          "redshift-data:GetStatementResult",
          "redshift-data:BatchExecuteStatement"
        ],
        Resource = "*"
      }
    ]
  })
}

# --- Attach policy to role ---
resource "aws_iam_role_policy_attachment" "attach_redshift" {
  role       = aws_iam_role.github_redshift_role.name
  policy_arn = aws_iam_policy.redshift_access.arn
}
