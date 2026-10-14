resource "hcloud_storage_box" "current" {
  name              = var.name
  storage_box_type  = var.type
  location          = var.location
  password          = var.password
  labels            = var.labels
  delete_protection = var.delete_protection
  access_settings   = var.access_settings
  snapshot_plan     = var.snapshot_plan
  ssh_keys          = var.ssh_keys
}

resource "hcloud_storage_box_subaccount" "current" {
  # Only stable map keys are public resource addresses; passwords stay sensitive.
  for_each = nonsensitive(toset(keys(var.subaccounts)))

  storage_box_id  = hcloud_storage_box.current.id
  name            = coalesce(var.subaccounts[each.key].name, each.key)
  home_directory  = var.subaccounts[each.key].home_directory
  password        = var.subaccounts[each.key].password
  description     = var.subaccounts[each.key].description
  labels          = merge(var.labels, var.subaccounts[each.key].labels)
  access_settings = var.subaccounts[each.key].access_settings
}
