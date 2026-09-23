resource "harbor_project" "projects" {
  for_each = { for project in var.projects : project.name => project }

  name                        = each.key
  public                      = each.value.public
  vulnerability_scanning      = each.value.vulnerability_scanning
  enable_content_trust        = each.value.enable_content_trust
  enable_content_trust_cosign = each.value.enable_content_trust_cosign
  auto_sbom_generation        = each.value.auto_sbom_generation
  cve_allowlist               = each.value.cve_allowlist
  deployment_security         = each.value.deployment_security
  force_destroy               = each.value.force_destroy
  storage_quota               = each.value.storage_quota

  # Fail fast when proxy_registry_name does not exist in available_registries
  registry_id = (each.value.proxy_registry_name != null && each.value.proxy_registry_name != "") ? var.available_registries[each.value.proxy_registry_name].registry_id : null
}
