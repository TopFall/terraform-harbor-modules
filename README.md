# terraform-harbor-modules

Reusable Terraform modules for managing [Harbor](https://goharbor.io/) container registries: projects, external registries, robot accounts, user and group memberships, and tag retention policies.

## Repository layout

```
modules/            one directory per module, each with its own tests (*.tftest.hcl)
examples/           runnable examples, one per module plus a complete setup
```

## Modules

| Module | Description |
|--------|-------------|
| [project](modules/project) | Harbor projects: content trust, SBOM, storage quotas, CVE allowlists, proxy cache |
| [registry](modules/registry) | External registries (upstream endpoints and proxy cache sources) |
| [robot-account](modules/robot-account) | Robot accounts with per-project permissions; secrets exposed via a sensitive output |
| [retention-policy](modules/retention-policy) | Tag retention policies per project |
| [user](modules/user) | Project memberships for users |
| [group](modules/group) | Groups and project memberships for groups |

## Requirements

| Name | Version |
|------|---------|
| [Terraform](https://developer.hashicorp.com/terraform/downloads) | >= 1.3 |
| [Harbor provider](https://registry.terraform.io/providers/goharbor/harbor/latest) | >= 3.11.2 |

## Usage

```hcl
terraform {
  required_providers {
    harbor = {
      source  = "goharbor/harbor"
      version = ">= 3.11.2"
    }
  }
}

provider "harbor" {
  url      = var.harbor_url
  username = var.harbor_username
  password = var.harbor_password
}

module "registries" {
  source = "git::https://github.com/TopFall/terraform-harbor-modules//modules/registry"

  registries = [
    {
      name          = "upstream"
      provider_name = "harbor"
      endpoint_url  = "https://harbor.example.com"
    },
  ]
}

module "projects" {
  source = "git::https://github.com/TopFall/terraform-harbor-modules//modules/project"

  projects = [
    { name = "app", vulnerability_scanning = true },
    { name = "proxy-cache", proxy_registry_name = "upstream" },
  ]

  available_registries = module.registries.registries
  depends_on           = [module.registries]
}

module "robot_accounts" {
  source = "git::https://github.com/TopFall/terraform-harbor-modules//modules/robot-account"

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

  depends_on = [module.projects]
}
```

See [examples/complete](examples/complete) for a full setup wiring all modules together, and each module's README for its inputs and outputs.

## Testing

Every module ships with `terraform test` suites built on the mock provider, so no live Harbor instance is required:

```sh
cd modules/<name>
terraform init
terraform test
```

## License

[Apache License 2.0](LICENSE)
