<p align="center">
    <!-- terraform-hetzner-storage-box -->
<img src="https://cdn.simpleicons.org/terraform/844FBA" alt="Terraform Logo" align="center" width="128">
<img src="https://avatars.githubusercontent.com/u/30047064?s=200&v=4" alt="Hetzner Logo" align="center" width="128">
    <h1 align="center">Hetzner Cloud</h1>
    <h2 align="center"><code>storage-box</code></h2>
</p>

[![License](https://img.shields.io/github/license/terraform-hetzner-modules/terraform-hetzner-storage-box?label=License)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/Terraform-_>=_1.7-brightgreen?logo=terraform&logoColor=623CE4)][terraform]
[![Opentofu](https://img.shields.io/badge/OpenTofu-_>=_1.11-brightgreen?logo=opentofu)][opentofu]
[![CI Status](https://github.com/terraform-hetzner-modules/terraform-hetzner-storage-box/actions/workflows/testing.yaml/badge.svg)](https://github.com/terraform-hetzner-modules/terraform-hetzner-storage-box/blob/main/.github/workflows/testing.yaml)
[![GitHub Release](https://img.shields.io/github/v/release/terraform-hetzner-modules/terraform-hetzner-storage-box?label=Release)][github_releases]
[![GitHub Activity](https://img.shields.io/github/commit-activity/m/terraform-hetzner-modules/terraform-hetzner-storage-box?label=Commits)][github_commits]
[![Renovate](https://img.shields.io/badge/Renovate-enabled-brightgreen?logo=renovate&logoColor=1A1F6C)][renovate]
[![Pre-Commit](https://img.shields.io/badge/PreCommit-enabled-brightgreen?logo=precommit&logoColor=FAB040)][pre-commit]

A [Terraform module][module] to manage a [Hetzner Storage Box][hetzner], its subaccounts, and snapshot settings.

## ✨ TL;DR

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

## Compatibility and examples

Requires Terraform >= 1.7 (OpenTofu >= 1.11 tested) and hcloud ~> 1.70.
See [basic](examples/basic) and [full](examples/full) examples; configure credentials through `HCLOUD_TOKEN`.
The generated [schema report](docs/SCHEMA.md) records provider fields and module mappings.
See the [maintenance and upgrade guide](docs/UPGRADING.md) for validation and coverage checks.
Run `terraform init -backend=false`, `terraform validate`, and `terraform test`
for credential-free validation and mocked tests.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | ~> 1.70 |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_access_settings"></a> [access\_settings](#input\_access\_settings) | Storage Box access settings. Null or omitted fields use provider defaults. | ```object({ reachable_externally = optional(bool) samba_enabled = optional(bool) ssh_enabled = optional(bool) webdav_enabled = optional(bool) zfs_enabled = optional(bool) })``` | `null` | no |
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | Protect against deletion outside Terraform. This does not prevent Terraform from destroying the box. | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels for the Storage Box and shared defaults for subaccounts. Subaccount labels take precedence. | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Storage Box location. Changing this replaces the box. | `string` | `"fsn1"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Storage Box. | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Primary password, subject to Hetzner's Storage Box password policy. Stored in Terraform state. | `string` | n/a | yes |
| <a name="input_snapshot_plan"></a> [snapshot\_plan](#input\_snapshot\_plan) | Automatic snapshot schedule in UTC. Null disables the plan. day\_of\_week uses 0=Sunday through 6=Saturday; null day fields mean every day. | ```object({ max_snapshots = number hour = number minute = number day_of_week = optional(number) day_of_month = optional(number) })``` | `null` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | Initial SSH public key contents (not Cloud SSH key IDs). Changing these keys replaces the entire Storage Box. Null uses the provider default. | `set(string)` | `null` | no |
| <a name="input_subaccounts"></a> [subaccounts](#input\_subaccounts) | Subaccounts keyed by stable, non-secret identifiers. Names default to map keys. Passwords are sensitive and stored in state; only map keys are declassified for resource addresses. | ```map(object({ name = optional(string) home_directory = string password = string description = optional(string) labels = optional(map(string), {}) access_settings = optional(object({ reachable_externally = optional(bool) samba_enabled = optional(bool) ssh_enabled = optional(bool) webdav_enabled = optional(bool) readonly = optional(bool) })) }))``` | `{}` | no |
| <a name="input_type"></a> [type](#input\_type) | Storage Box type, for example bx21. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_access_settings"></a> [access\_settings](#output\_access\_settings) | Effective Storage Box access settings. |
| <a name="output_delete_protection"></a> [delete\_protection](#output\_delete\_protection) | Deletion protection setting. |
| <a name="output_id"></a> [id](#output\_id) | Storage Box ID. |
| <a name="output_labels"></a> [labels](#output\_labels) | Storage Box labels. |
| <a name="output_location"></a> [location](#output\_location) | Storage Box location. |
| <a name="output_name"></a> [name](#output\_name) | Storage Box name. |
| <a name="output_server"></a> [server](#output\_server) | Storage Box FQDN. |
| <a name="output_snapshot_plan"></a> [snapshot\_plan](#output\_snapshot\_plan) | Active automatic snapshot plan, or null. |
| <a name="output_ssh_keys"></a> [ssh\_keys](#output\_ssh\_keys) | Initial SSH public keys. |
| <a name="output_subaccount_ids"></a> [subaccount\_ids](#output\_subaccount\_ids) | Subaccount IDs keyed by caller identifiers. |
| <a name="output_subaccount_servers"></a> [subaccount\_servers](#output\_subaccount\_servers) | Subaccount FQDNs keyed by caller identifiers. |
| <a name="output_subaccount_usernames"></a> [subaccount\_usernames](#output\_subaccount\_usernames) | Subaccount usernames keyed by caller identifiers. |
| <a name="output_subaccounts"></a> [subaccounts](#output\_subaccounts) | Subaccount attributes without passwords, keyed by caller identifiers. Sensitive because account configuration may contain sensitive values. |
| <a name="output_system"></a> [system](#output\_system) | Storage Box host system. |
| <a name="output_type"></a> [type](#output\_type) | Storage Box type. |
| <a name="output_username"></a> [username](#output\_username) | Primary username. |
<!-- END_TF_DOCS -->

### 🔃 Contributing

Refer to our [documentation for contributors][contributing] for contributing guidelines, commit message
formats and versioning tips.

### 📥 Maintainers

This project is owned and maintained by [Terraform Hetzner Modules][org]. Refer to the [`AUTHORS`][authors] or [`CODEOWNERS`][owners]
for more information. You may also use the linked contact details to reach out directly.

### ©️ Copyright

- _Assets provided by:_ **[HashiCorp][hashicorp]**
- _Sources provided by:_ **[Terraform Hetzner Modules][org]** under the **[MIT License][license]**

<!-- INTERNAL REFERENCES -->

<!-- Project references -->

<!-- File references -->

[license]: LICENSE
[contributing]: docs/CONTRIBUTING.md
[authors]: .github/AUTHORS
[owners]: .github/CODEOWNERS

<!-- General links -->

[org]: https://github.com/terraform-hetzner-modules
[terraform]: https://terraform.io
[opentofu]: https://opentofu.org/
[hashicorp]: https://www.hashicorp.com/
[hetzner]: https://hetzner.com
[github_releases]: https://github.com/terraform-hetzner-modules/terraform-hetzner-storage-box/releases
[github_commits]: https://github.com/terraform-hetzner-modules/terraform-hetzner-storage-box/commits/main/

<!-- Third-party -->

[module]: https://registry.terraform.io/modules/terraform-hetzner-modules/storage-box/hetzner/latest
[renovate]: https://renovatebot.com/
[pre-commit]: https://pre-commit.com/
