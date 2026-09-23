mock_provider "harbor" {
  override_resource {
    target = harbor_registry.registries

    values = {
      registry_id = 7
      status      = "healthy"
    }

    override_during = plan
  }
}

run "creates_registries" {
  command = plan

  variables {
    registries = [
      { name = "upstream", provider_name = "harbor", endpoint_url = "https://harbor.example.com" },
      { name = "mirror", provider_name = "harbor", endpoint_url = "https://harbor-mirror.example.com", insecure = true },
    ]
  }

  assert {
    condition     = length(harbor_registry.registries) == 2
    error_message = "expected two Harbor registries"
  }

  assert {
    condition     = harbor_registry.registries["upstream"].registry_id == 7 && harbor_registry.registries["upstream"].status == "healthy"
    error_message = "computed registry_id and status must come from the provider"
  }

  assert {
    condition     = harbor_registry.registries["mirror"].endpoint_url == "https://harbor-mirror.example.com"
    error_message = "endpoint_url must be passed through"
  }

  assert {
    condition     = harbor_registry.registries["mirror"].insecure == true
    error_message = "insecure must be passed through"
  }
}

run "fails_on_duplicate_names" {
  command = plan

  variables {
    registries = [
      { name = "dup", provider_name = "harbor", endpoint_url = "https://a.example.com" },
      { name = "dup", provider_name = "harbor", endpoint_url = "https://b.example.com" },
    ]
  }

  expect_failures = [var.registries]
}
