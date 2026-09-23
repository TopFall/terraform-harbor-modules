# user

Grants Harbor users membership in projects. Users must already exist in Harbor (e.g. via OIDC/LDAP authentication); this module only manages their project roles.

`role` accepts Harbor project roles: `projectadmin`, `maintainer`, `developer`, `guest`, `limitedguest`.

## Example

```hcl
module "users" {
  source = "../../modules/user"

  users = [
    {
      name = "alice"
      projects = [
        { name = "app", role = "developer" },
        { name = "libs", role = "guest" },
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
| users | List of users and their project memberships | `list(object)` | n/a | yes |
| users[*].name | Harbor user name | `string` | n/a | yes |
| users[*].projects | Project memberships | `list(object)` | n/a | yes |
| users[*].projects[*].name | Project name | `string` | n/a | yes |
| users[*].projects[*].role | Project role | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| memberships | Map of project member users keyed by `<user_name>-<project_name>` |
