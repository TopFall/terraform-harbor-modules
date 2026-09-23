# registry

Registers external registries in Harbor. These can be used directly for replication or as proxy cache sources for projects.

`provider_name` must be one of Harbor's registry adapter types (for example `harbor`, `docker-hub`, `aws-ecr`, `azure-acr`, `gcr`, `quay`, `gitlab`, `jfrog-artifactory`).

## Example

```hcl
module "registries" {
  source = "../../modules/registry"

  registries = [
    {
      name          = "upstream"
      provider_name = "harbor"
      endpoint_url  = "https://harbor.example.com"
    },
    {
      name          = "docker-hub"
      provider_name = "docker-hub"
      endpoint_url  = "https://hub.docker.com"
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
| registries | List of external registries to register | `list(object)` | n/a | yes |
| registries[*].name | Registry name in Harbor | `string` | n/a | yes |
| registries[*].provider_name | Harbor registry adapter type | `string` | n/a | yes |
| registries[*].endpoint_url | Registry endpoint URL | `string` | n/a | yes |
| registries[*].description | Registry description | `string` | `null` | no |
| registries[*].access_id | Access ID (username / access key) | `string` | `null` | no |
| registries[*].access_secret | Access secret (password / secret key) | `string` | `null` | no |
| registries[*].insecure | Skip TLS verification | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| registries | Map of registered registries keyed by name (`registry_id`, `name`, `endpoint_url`, `status`). Safe to pass to the [project](../project) module. |
