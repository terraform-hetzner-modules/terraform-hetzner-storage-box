mock_provider "hcloud" {
  mock_resource "hcloud_storage_box" { defaults = { id = 42, username = "u42", server = "u42.example.com", system = "test-system" } }
  mock_resource "hcloud_storage_box_subaccount" { defaults = { id = 7, username = "u42-sub7", server = "u42-sub7.example.com" } }
}

variables {
  name     = "test-box"
  type     = "bx21"
  password = "mock-only-primary-password"
}

run "no_subaccounts_by_default" {
  command = apply
  assert {
    condition     = length(output.subaccounts) == 0 && output.delete_protection && output.snapshot_plan == null
    error_message = "Default boxes must have no subaccounts or schedule, with external delete protection enabled."
  }
  assert {
    condition     = output.id == 42 && output.username == "u42" && output.server == "u42.example.com" && output.system == "test-system"
    error_message = "Storage Box connection attributes must be exported."
  }
}

run "full_configuration_and_subaccounts" {
  command = apply
  variables {
    location          = "hel1"
    delete_protection = false
    labels            = { environment = "production", managed_by = "terraform" }
    ssh_keys          = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAABAgMEBQYHCAkKCwwNDg8QERITFBUWFxgZGhscHR4f terraform-test"]
    access_settings = {
      reachable_externally = true
      samba_enabled        = true
      ssh_enabled          = true
      webdav_enabled       = false
      zfs_enabled          = true
    }
    snapshot_plan = { max_snapshots = 10, hour = 2, minute = 15, day_of_week = 0 }
    subaccounts = {
      backups = {
        home_directory = "backups"
        password       = "mock-only-backup-password"
        description    = "Backup writer"
        labels         = { environment = "backup" }
        access_settings = {
          reachable_externally = true
          samba_enabled        = false
          ssh_enabled          = true
          webdav_enabled       = false
          readonly             = false
        }
      }
      reader = {
        name            = "audit-reader"
        home_directory  = "backups"
        password        = "mock-only-reader-password"
        access_settings = { readonly = true }
      }
    }
  }
  assert {
    condition     = output.location == "hel1" && !output.delete_protection && output.access_settings.ssh_enabled && output.access_settings.zfs_enabled && !output.access_settings.webdav_enabled
    error_message = "Box settings must reach the provider without losing false values."
  }
  assert {
    condition     = output.snapshot_plan.day_of_week == 0 && output.snapshot_plan.day_of_month == null && output.snapshot_plan.max_snapshots == 10 && output.snapshot_plan.hour == 2 && output.snapshot_plan.minute == 15 && length(output.ssh_keys) == 1
    error_message = "Sunday, omitted day fields, retention, times, and initial SSH keys must survive unchanged."
  }
  assert {
    condition     = keys(output.subaccount_ids) == ["backups", "reader"] && output.subaccounts.backups.storage_box_id == output.id && output.subaccounts.reader.name == "audit-reader" && output.subaccounts.backups.name == "backups"
    error_message = "Sensitive account maps must retain stable resource keys, names, and the parent dependency."
  }
  assert {
    condition     = output.subaccounts.reader.access_settings.readonly && !output.subaccounts.backups.access_settings.readonly && output.subaccounts.backups.labels.environment == "backup" && output.subaccounts.backups.labels.managed_by == "terraform"
    error_message = "Subaccount permissions and label overrides must be preserved."
  }
  assert {
    condition     = alltrue([for account in values(output.subaccounts) : !contains(keys(account), "password")]) && output.subaccount_usernames.backups == "u42-sub7" && output.subaccount_servers.backups == "u42-sub7.example.com"
    error_message = "Outputs must expose connection metadata without re-exporting passwords."
  }
}

run "monthly_schedule" {
  command = plan
  variables {
    snapshot_plan = { max_snapshots = 3, hour = 23, minute = 59, day_of_month = 15 }
  }
  assert {
    condition     = output.snapshot_plan.day_of_month == 15 && output.snapshot_plan.day_of_week == null
    error_message = "Monthly schedules must preserve day_of_month without setting a weekday."
  }
}

run "reject_absolute_home_directory" {
  command = plan
  variables {
    subaccounts = { invalid = { home_directory = "/backups", password = "test" } }
  }
  expect_failures = [var.subaccounts]
}
