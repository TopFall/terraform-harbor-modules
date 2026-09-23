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
