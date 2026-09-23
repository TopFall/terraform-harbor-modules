# project

Manages Harbor projects: visibility, vulnerability scanning, content trust, SBOM generation, storage quotas, CVE allowlists and proxy cache configuration.

## Example

```hcl
module "projects" {
  source = "../../modules/project"

  projects = [
    { name = "app", vulnerability_scanning = true },
    { name = "proxy-cache", proxy_registry_name = "upstream" },
  ]

  available_registries = module.registries.registries
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
| projects | List of Harbor projects to manage | `list(object)` | n/a | yes |
| projects[*].name | Project name | `string` | n/a | yes |
| projects[*].public | Project visibility | `bool` | `false` | no |
| projects[*].vulnerability_scanning | Automatically scan images on push | `bool` | `false` | no |
| projects[*].enable_content_trust | Require content trust (Notary) | `bool` | `false` | no |
| projects[*].enable_content_trust_cosign | Require cosign content trust | `bool` | `false` | no |
| projects[*].auto_sbom_generation | Automatically generate SBOM on push | `bool` | `false` | no |
| projects[*].cve_allowlist | List of CVE IDs to ignore | `list(string)` | `[]` | no |
| projects[*].deployment_security | Deployment security policy | `string` | `null` | no |
| projects[*].force_destroy | Allow deleting non-empty projects | `bool` | `false` | no |
| projects[*].storage_quota | Storage quota in bytes (-1 = unlimited) | `number` | `-1` | no |
| projects[*].proxy_registry_name | Registry name from `available_registries` to use as proxy cache | `string` | `null` | no |
| available_registries | Output `registries` of the [registry](../registry) module | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| projects | Map of Harbor projects keyed by project name |
| project_ids | Map of Harbor project IDs keyed by project name |
