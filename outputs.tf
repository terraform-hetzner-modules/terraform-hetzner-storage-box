output "id" {
  description = "Storage Box ID."
  value       = hcloud_storage_box.current.id
}

output "name" {
  description = "Storage Box name."
  value       = hcloud_storage_box.current.name
}

output "type" {
  description = "Storage Box type."
  value       = hcloud_storage_box.current.storage_box_type
}

output "location" {
  description = "Storage Box location."
  value       = hcloud_storage_box.current.location
}

output "server" {
  description = "Storage Box FQDN."
  value       = hcloud_storage_box.current.server
}

output "username" {
  description = "Primary username."
  value       = hcloud_storage_box.current.username
}

output "system" {
  description = "Storage Box host system."
  value       = hcloud_storage_box.current.system
}

output "labels" {
  description = "Storage Box labels."
  value       = hcloud_storage_box.current.labels
}

output "delete_protection" {
  description = "Deletion protection setting."
  value       = hcloud_storage_box.current.delete_protection
}

output "access_settings" {
  description = "Effective Storage Box access settings."
  value       = hcloud_storage_box.current.access_settings
}

output "snapshot_plan" {
  description = "Active automatic snapshot plan, or null."
  value       = hcloud_storage_box.current.snapshot_plan
}

output "ssh_keys" {
  description = "Initial SSH public keys."
  value       = hcloud_storage_box.current.ssh_keys
}

output "subaccounts" {
  description = "Subaccount attributes without passwords, keyed by caller identifiers. Sensitive because account configuration may contain sensitive values."
  sensitive   = true
  value = {
    for key, account in hcloud_storage_box_subaccount.current : key => {
      id              = account.id
      storage_box_id  = account.storage_box_id
      name            = account.name
      home_directory  = account.home_directory
      description     = account.description
      labels          = account.labels
      access_settings = account.access_settings
      server          = account.server
      username        = account.username
    }
  }
}

output "subaccount_ids" {
  description = "Subaccount IDs keyed by caller identifiers."
  value       = { for key, account in hcloud_storage_box_subaccount.current : key => account.id }
}

output "subaccount_usernames" {
  description = "Subaccount usernames keyed by caller identifiers."
  value       = { for key, account in hcloud_storage_box_subaccount.current : key => account.username }
}

output "subaccount_servers" {
  description = "Subaccount FQDNs keyed by caller identifiers."
  value       = { for key, account in hcloud_storage_box_subaccount.current : key => account.server }
}
