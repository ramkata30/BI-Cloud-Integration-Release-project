# How This Works

OIDC Provider → Trusts GitHub’s OIDC tokens.

IAM Role (GitHubRedshiftOIDCRole) → Can be assumed by GitHub Actions runs from your repo.

Replace <YOUR_ORG>/<YOUR_REPO> in the sub condition with your GitHub org & repo.

You can restrict to a specific branch or allow all (*).

Redshift Permissions → Role can request temporary credentials and execute SQL using Redshift Data API.
