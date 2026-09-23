mock_provider "harbor" {}

run "creates_all_projects" {
  command = plan

  variables {
    projects = [
      { name = "app" },
      { name = "libs", public = true, storage_quota = 10737418240, cve_allowlist = ["CVE-2026-1234"] },
    ]
  }

  assert {
    condition     = length(harbor_project.projects) == 2
    error_message = "expected two Harbor projects"
  }

  assert {
    condition     = harbor_project.projects["app"].public == false && harbor_project.projects["app"].storage_quota == -1
    error_message = "optional attributes must fall back to their defaults"
  }

  assert {
    condition     = harbor_project.projects["libs"].cve_allowlist == tolist(["CVE-2026-1234"])
    error_message = "cve_allowlist must be passed through"
  }
}

run "resolves_proxy_registry_id" {
  command = plan

  variables {
    projects = [
      { name = "proxy-cache", proxy_registry_name = "dockerhub" },
    ]
    available_registries = {
      dockerhub = { registry_id = 42, name = "dockerhub", endpoint_url = "https://registry-1.docker.io" }
    }
  }

  assert {
    condition     = harbor_project.projects["proxy-cache"].registry_id == 42
    error_message = "proxy registry_id must be resolved from available_registries"
  }
}

run "fails_on_duplicate_names" {
  command = plan

  variables {
    projects = [
      { name = "dup" },
      { name = "dup" },
    ]
  }

  expect_failures = [var.projects]
}
