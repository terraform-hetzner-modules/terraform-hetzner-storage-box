mock_provider "hcloud" {
  mock_resource "hcloud_storage_box_snapshot" { defaults = { id = 123, name = "test-snapshot", is_automatic = false } }
}

run "snapshot_defaults" {
  command = apply
  module { source = "./modules/snapshot" }
  variables { storage_box_id = 42 }
  assert {
    condition     = output.storage_box_id == 42 && length(output.labels) == 0
    error_message = "A snapshot must retain its parent ID and default empty labels."
  }
}

run "snapshot_metadata" {
  command = apply
  module { source = "./modules/snapshot" }
  variables {
    storage_box_id = 43
    description    = "Before migration"
    labels         = { purpose = "migration" }
  }
  assert {
    condition     = output.storage_box_id == 43 && output.description == "Before migration" && output.labels.purpose == "migration"
    error_message = "Snapshot parent, description, and labels must be configurable."
  }
  assert {
    condition     = output.name == "test-snapshot" && !output.is_automatic
    error_message = "Snapshot-specific settings and computed attributes must be preserved."
  }
}
