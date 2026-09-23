# robot-account

Manages Harbor robot accounts with per-project or system-wide permissions. Generated secrets are exposed through a sensitive output — store them in your secrets manager of choice (Vault, SSM, etc.).

## Example

```hcl
module "robot_accounts" {
  source = "../../modules/robot-account"

  robot_accounts = [
    {
      name        = "ci-push"
      level       = "project"
      description = "CI push account"
      permissions = [
        {
          kind      = "project"
          namespace = "app"
          access = [
            { action = "pull", resource = "repository" },
            { action = "push", resource = "repository" },
          ]
        },
      ]
      duration = 30
    },
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| harbor | >= 3.11.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| robot_accounts | List of robot accounts to manage | `list(object)` | n/a | yes |
| robot_accounts[*].name | Robot account name | `string` | n/a | yes |
| robot_accounts[*].level | `project` or `system` | `string` | n/a | yes |
| robot_accounts[*].description | Robot account description | `string` | n/a | yes |
| robot_accounts[*].permissions | Permission blocks | `list(object)` | n/a | yes |
| robot_accounts[*].permissions[*].kind | `project` or `system` | `string` | n/a | yes |
| robot_accounts[*].permissions[*].namespace | Project name or `/` for system | `string` | n/a | yes |
| robot_accounts[*].permissions[*].access | Access entries (`action`, `resource`, optional `effect`) | `list(object)` | n/a | yes |
| robot_accounts[*].disabled | Disable the account | `bool` | `false` | no |
| robot_accounts[*].duration | Account lifetime in days (-1 = never expires) | `number` | `-1` | no |
| robot_accounts[*].secret | Predefined secret (Harbor generates one when unset) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| robot_accounts | Map of robot accounts keyed by name (non-sensitive attributes) |
| secrets | Map of robot account secrets keyed by name (sensitive) |
| robot_ids | Map of Harbor robot IDs keyed by name |
