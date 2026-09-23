# Only non-sensitive attributes are exposed, so this output can be passed to
# the project module (available_registries) without leaking access secrets.
output "registries" {
  description = "Map of registered Harbor registries keyed by registry name."
  value = {
    for name, registry in harbor_registry.registries : name => {
      registry_id  = registry.registry_id
      name         = registry.name
      endpoint_url = registry.endpoint_url
      status       = registry.status
    }
  }
}
