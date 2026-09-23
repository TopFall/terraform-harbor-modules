terraform {
  required_version = ">= 1.3"

  required_providers {
    harbor = {
      source  = "goharbor/harbor"
      version = ">= 3.11.2"
    }
  }
}
