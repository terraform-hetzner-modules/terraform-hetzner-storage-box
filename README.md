# Hetzner Storage Box Terraform module

Manage a Storage Box, subaccounts, access settings, and automatic snapshots. A submodule supports manual snapshots.

## Usage

Copy this configuration into `main.tf`.

```hcl
variable "storage_box_password" {
  type      = string
  sensitive = true
}

module "storage_box" {
  source = "terraform-hetzner-modules/storage-box/hetzner"

  name     = "archives"
  type     = "bx21"
  password = var.storage_box_password
  access_settings = {
    ssh_enabled          = true
    reachable_externally = true
  }
}
```

Supply `storage_box_password` through a sensitive variable or your secret-management system.
The module outputs the connection hostname as `server` and account name as `username`.

## Examples

- [Basic](examples/basic): a Storage Box.
- [Full](examples/full): every input and nested setting, subaccounts, and automatic and manual snapshots.

## Accounts and access

`subaccounts` accepts any number of accounts keyed by stable, non-secret identifiers known during planning.
Names default to map keys. Other values, including passwords, may be computed.
Home directories are relative to the Storage Box root, without a leading slash.
Shared `labels` apply to the box and subaccounts; per-account labels override shared labels.
Box and subaccount access settings are independent. Omitted settings delegate to provider defaults.

Passwords are sensitive inputs, but the provider still stores them in Terraform state. Protect the state
and saved plans. Passwords are excluded from outputs. The `subaccounts` output retains sensitivity for
account configuration; `subaccount_ids`, `subaccount_usernames`, and `subaccount_servers` expose connection
identifiers by map key. The main account's connection details are available as `server` and `username`.

`ssh_keys` accepts initial public key contents, not Hetzner Cloud SSH key IDs. Changing these keys or the
location replaces the entire Storage Box. Manage subsequent authorized-key changes on the box itself.
Deletion protection defaults to true, but protects against deletion outside Terraform only: the provider
clears protection during Terraform destruction. Review replacement and destroy plans carefully.

## Snapshots

`snapshot_plan` configures automatic snapshots with a retention count and UTC hour/minute.
Optional `day_of_week` uses 0 for Sunday through 6 for Saturday; `day_of_month` selects a monthly day.
Omitting both day fields schedules daily snapshots. Null disables the automatic plan.

The optional [snapshot submodule](modules/snapshot) manages individual manual snapshots.
See the [full example](examples/full) for both automatic scheduling and a manual snapshot.
Manual snapshots capture a point in time and do not refresh when files change.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >= 1.7 |
| hcloud | ~> 1.70 |

## Providers

| Name | Version |
| ---- | ------- |
| hcloud | ~> 1.70 |

## Resources

| Name | Type |
| ---- | ---- |
| [hcloud_storage_box.current](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/storage_box) | resource |
| [hcloud_storage_box_subaccount.current](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/storage_box_subaccount) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| access\_settings | Storage Box access settings. Null or omitted fields use provider defaults. | ```object({ reachable_externally = optional(bool) samba_enabled = optional(bool) ssh_enabled = optional(bool) webdav_enabled = optional(bool) zfs_enabled = optional(bool) })``` | `null` | no |
| delete\_protection | Protect against deletion outside Terraform. This does not prevent Terraform from destroying the box. | `bool` | `true` | no |
| labels | Labels for the Storage Box and shared defaults for subaccounts. Subaccount labels take precedence. | `map(string)` | `{}` | no |
| location | Storage Box location. Changing this replaces the box. | `string` | `"fsn1"` | no |
| name | Name of the Storage Box. | `string` | n/a | yes |
| password | Primary password, subject to Hetzner's Storage Box password policy. Stored in Terraform state. | `string` | n/a | yes |
| snapshot\_plan | Automatic snapshot schedule in UTC. Null disables the plan. day\_of\_week uses 0=Sunday through 6=Saturday; null day fields mean every day. | ```object({ max_snapshots = number hour = number minute = number day_of_week = optional(number) day_of_month = optional(number) })``` | `null` | no |
| ssh\_keys | Initial SSH public key contents (not Cloud SSH key IDs). Changing these keys replaces the entire Storage Box. Null uses the provider default. | `set(string)` | `null` | no |
| subaccounts | Subaccounts keyed by stable, non-secret identifiers. Names default to map keys. Passwords are sensitive and stored in state; only map keys are declassified for resource addresses. | ```map(object({ name = optional(string) home_directory = string password = string description = optional(string) labels = optional(map(string), {}) access_settings = optional(object({ reachable_externally = optional(bool) samba_enabled = optional(bool) ssh_enabled = optional(bool) webdav_enabled = optional(bool) readonly = optional(bool) })) }))``` | `{}` | no |
| type | Storage Box type, for example bx21. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| access\_settings | Effective Storage Box access settings. |
| delete\_protection | Deletion protection setting. |
| id | Storage Box ID. |
| labels | Storage Box labels. |
| location | Storage Box location. |
| name | Storage Box name. |
| server | Storage Box FQDN. |
| snapshot\_plan | Active automatic snapshot plan, or null. |
| ssh\_keys | Initial SSH public keys. |
| subaccount\_ids | Subaccount IDs keyed by caller identifiers. |
| subaccount\_servers | Subaccount FQDNs keyed by caller identifiers. |
| subaccount\_usernames | Subaccount usernames keyed by caller identifiers. |
| subaccounts | Subaccount attributes without passwords, keyed by caller identifiers. Sensitive because account configuration may contain sensitive values. |
| system | Storage Box host system. |
| type | Storage Box type. |
| username | Primary username. |
<!-- END_TF_DOCS -->

## Contributing

See [CONTRIBUTING.md](docs/CONTRIBUTING.md) for local checks and contribution guidelines, and
[UPGRADING.md](docs/UPGRADING.md) for compatibility and live acceptance checks. The generated
[schema report](docs/SCHEMA.md) documents provider coverage and intentional omissions.

## Authors

Maintained by [Terraform Hetzner Modules](https://github.com/terraform-hetzner-modules).
See [AUTHORS](.github/AUTHORS) and [CODEOWNERS](.github/CODEOWNERS).

## License

MIT. See [LICENSE](LICENSE).
