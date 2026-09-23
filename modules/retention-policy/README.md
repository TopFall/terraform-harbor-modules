# retention-policy

Manages Harbor tag retention policies, one per project. Policies are keyed by project name; projects must already exist.

`schedule` accepts Harbor schedule values: `hourly`, `daily`, `weekly`, or a cron expression.

Every rule must select exactly one retention criterion: `always_retain`, `most_recently_pulled`, `most_recently_pushed`, `n_days_since_last_pull`, `n_days_since_last_push`, or `untagged_artifacts`.

## Example

```hcl
module "retention_policies" {
  source = "../../modules/retention-policy"

  policies = {
    app = {
      schedule = "daily"
      rules = [
        { most_recently_pulled = 10, tag_matching = "**" },
        { n_days_since_last_push = 30, repo_matching = "release/**" },
      ]
    }
    libs = {
      rules = [{ untagged_artifacts = true }]
    }
  }
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
| policies | Map of retention policies keyed by project name | `map(object)` | `{}` | no |
| policies[*].schedule | Retention run schedule | `string` | `null` | no |
| policies[*].rules | Retention rules | `list(object)` | n/a | yes |
| policies[*].rules[*].always_retain | Always retain matching artifacts | `bool` | `null` | no |
| policies[*].rules[*].disabled | Disable the rule | `bool` | `null` | no |
| policies[*].rules[*].most_recently_pulled | Retain N most recently pulled artifacts | `number` | `null` | no |
| policies[*].rules[*].most_recently_pushed | Retain N most recently pushed artifacts | `number` | `null` | no |
| policies[*].rules[*].n_days_since_last_pull | Retain artifacts pulled within N days | `number` | `null` | no |
| policies[*].rules[*].n_days_since_last_push | Retain artifacts pushed within N days | `number` | `null` | no |
| policies[*].rules[*].repo_excluding | Repositories to exclude (glob) | `string` | `null` | no |
| policies[*].rules[*].repo_matching | Repositories to include (glob) | `string` | `null` | no |
| policies[*].rules[*].tag_excluding | Tags to exclude (glob) | `string` | `null` | no |
| policies[*].rules[*].tag_matching | Tags to include (glob) | `string` | `null` | no |
| policies[*].rules[*].untagged_artifacts | Apply the rule to untagged artifacts | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| policies | Map of retention policies keyed by project name |
