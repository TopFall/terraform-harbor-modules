terraform {
  required_version = ">= 1.3"

  required_providers {
    harbor = {
      source  = "goharbor/harbor"
      version = ">= 3.11.2"
    }
  }
}

# Real provider configuration for running `terraform test` with the mock provider.
provider "harbor" {
  url = "https://harbor.example.com"
}
