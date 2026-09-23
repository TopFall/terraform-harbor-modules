mock_provider "harbor" {
  override_resource {
    target = module.projects.harbor_project.projects

    values = {
      id = "/projects/1"
    }

    override_during = plan
  }

  override_resource {
    target = module.registries.harbor_registry.registries

    values = {
      registry_id = 3
    }

    override_during = plan
  }
}

run "outputs_project_ids" {
  command = plan

  assert {
    condition     = module.projects.project_ids["app"] == "/projects/1"
    error_message = "project_ids output must expose project ids keyed by name"
  }

  assert {
    condition     = module.projects.projects["proxy-cache"].registry_id == 3
    error_message = "proxy projects must reference the upstream registry"
  }
}
