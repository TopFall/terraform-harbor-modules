mock_provider "harbor" {
  override_resource {
    target = module.registries.harbor_registry.registries

    values = {
      registry_id = 3
      status      = "healthy"
    }

    override_during = plan
  }
}

run "outputs_registries" {
  command = plan

  assert {
    condition     = module.registries.registries["upstream"].registry_id == 3 && module.registries.registries["upstream"].status == "healthy"
    error_message = "registries output must expose registry_id and status"
  }

  assert {
    condition     = length(module.registries.registries) == 2
    error_message = "registries output must contain every registry"
  }
}
