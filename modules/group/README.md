# group

Manages Harbor groups and grants them membership in projects. Groups are typically provisioned by an identity provider (LDAP/OIDC); this module registers them in Harbor and manages their project roles.

`type` is the Harbor group type: `0` = LDAP, `1` = HTTP, `2` = OIDC. The membership `type` is the same value as a string (`ldap`, `http`, `oidc`). `role` accepts Harbor project roles: `projectadmin`, `maintainer`, `developer`, `guest`, `limitedguest`.

## Example

```hcl
module "groups" {
  source = "../../modules/group"

  groups = [
    {
      name = "sre"
      type = 2 # OIDC
      projects = [
        { name = "app", role = "maintainer", type = "oidc" },
      ]
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
| groups | List of Harbor groups | `list(object)` | n/a | yes |
| groups[*].name | Group name | `string` | n/a | yes |
| groups[*].type | Harbor group type (0 = LDAP, 1 = HTTP, 2 = OIDC) | `number` | n/a | yes |
| groups[*].projects | Project memberships (optional) | `list(object)` | `[]` | no |
| groups[*].projects[*].name | Project name | `string` | n/a | yes |
| groups[*].projects[*].role | Project role | `string` | n/a | yes |
| groups[*].projects[*].type | Membership type (`ldap`, `http`, `oidc`) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| groups | Map of Harbor groups keyed by name |
| memberships | Map of project member groups keyed by `<group_name>-<project_name>` |
