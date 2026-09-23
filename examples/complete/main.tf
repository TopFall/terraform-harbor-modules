variable "harbor_url" {
  description = "Harbor instance URL."
  type        = string
  default     = "https://harbor.example.com"
}

variable "harbor_username" {
  description = "Harbor admin username."
  type        = string
}

variable "harbor_password" {
  description = "Harbor admin password."
  type        = string
  sensitive   = true
}

provider "harbor" {
  url      = var.harbor_url
  username = var.harbor_username
  password = var.harbor_password
}

module "registries" {
  source = "../../modules/registry"

  registries = [
    {
      name          = "upstream"
      provider_name = "harbor"
      endpoint_url  = "https://harbor.example.com"
    },
  ]
}

module "projects" {
  source = "../../modules/project"

  projects = [
    { name = "app", vulnerability_scanning = true },
    { name = "proxy-cache", proxy_registry_name = "upstream" },
  ]

  available_registries = module.registries.registries
  depends_on           = [module.registries]
}

module "retention_policies" {
  source = "../../modules/retention-policy"

  policies = {
    app = {
      schedule = "daily"
      rules = [
        { most_recently_pulled = 10, tag_matching = "**" },
      ]
    }
  }

  depends_on = [module.projects]
}

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

  depends_on = [module.projects]
}

module "users" {
  source = "../../modules/user"

  users = [
    {
      name     = "alice"
      projects = [{ name = "app", role = "developer" }]
    },
  ]

  depends_on = [module.projects]
}

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

  depends_on = [module.projects]
}

output "ci_robot_secret" {
  description = "Secret of the ci-push robot account."
  value       = module.robot_accounts.secrets["ci-push"]
  sensitive   = true
}
