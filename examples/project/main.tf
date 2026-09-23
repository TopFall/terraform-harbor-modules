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
