terraform {
  required_version = ">= 1.7"
  required_providers {
    hcloud = { source = "hetznercloud/hcloud", version = "~> 1.70" }
  }
}

resource "terraform_data" "password" { input = "mock-only-computed-password" }

module "subject" {
  source   = "../.."
  name     = "computed-passwords"
  type     = "bx21"
  password = sensitive(terraform_data.password.output)
  subaccounts = {
    backups = { home_directory = "backups", password = sensitive(terraform_data.password.output) }
  }
}

module "snapshot" {
  source         = "../../modules/snapshot"
  storage_box_id = module.subject.id
}

output "subaccount_ids" {
  description = "Subaccount map retains known keys with computed passwords."
  value       = module.subject.subaccount_ids
}
