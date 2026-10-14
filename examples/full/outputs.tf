output "server" {
  description = "Storage Box FQDN."
  value       = module.storage_box.server
}

output "username" {
  description = "Primary username."
  value       = module.storage_box.username
}

output "subaccount_usernames" {
  description = "Subaccount usernames indexed by their stable map keys."
  value       = module.storage_box.subaccount_usernames
}

output "snapshot_id" {
  description = "ID of the manually managed snapshot."
  value       = module.snapshot.id
}
