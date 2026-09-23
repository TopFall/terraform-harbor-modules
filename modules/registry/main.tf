resource "harbor_registry" "registries" {
  for_each = { for registry in var.registries : registry.name => registry }

  provider_name = each.value.provider_name
  name          = each.key
  endpoint_url  = each.value.endpoint_url
  description   = each.value.description
  access_id     = each.value.access_id
  access_secret = each.value.access_secret
  insecure      = each.value.insecure
}
