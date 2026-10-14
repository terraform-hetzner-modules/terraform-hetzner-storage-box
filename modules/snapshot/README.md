# Storage Box snapshot

Manage a manual snapshot of an existing Storage Box using `hcloud_storage_box_snapshot`.
The parent module does not create snapshots automatically; invoke this submodule explicitly.

```hcl
module "snapshot" {
  source = "terraform-hetzner-modules/storage-box/hetzner//modules/snapshot"

  storage_box_id = module.storage_box.id
  description = "Before maintenance"
  labels      = { purpose = "maintenance" }
}
```

A snapshot captures a point in time. File changes on the parent do not refresh an existing snapshot.
To capture a new point in time, add another module instance or deliberately replace this resource.
Changing the parent ID replaces the snapshot. Destroying this module deletes its snapshot.
Ensure any required provisioning or application quiescing has completed before creating a snapshot;
Terraform dependencies alone do not guarantee an application-consistent backup.

Snapshot names and the `is_automatic` flag are provider-managed outputs.
Use the parent module's `snapshot_plan` for automatic snapshots and retention.

See the [schema report](docs/SCHEMA.md) for the resource inventory.
Run `formr schema . -o docs/SCHEMA.md` here to regenerate it.
The parent repository's native Terraform tests cover this submodule with a mock provider.

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
| <a name="input_description"></a> [description](#input\_description) | Description of the snapshot. Null uses the provider default. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels attached to the snapshot. | `map(string)` | `{}` | no |
| <a name="input_storage_box_id"></a> [storage\_box\_id](#input\_storage\_box\_id) | ID of the source Storage Box. Changing this replaces the snapshot. | `number` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_description"></a> [description](#output\_description) | Snapshot description. |
| <a name="output_id"></a> [id](#output\_id) | Snapshot id. |
| <a name="output_is_automatic"></a> [is\_automatic](#output\_is\_automatic) | Snapshot is automatic. |
| <a name="output_labels"></a> [labels](#output\_labels) | Snapshot labels. |
| <a name="output_name"></a> [name](#output\_name) | Snapshot name. |
| <a name="output_storage_box_id"></a> [storage\_box\_id](#output\_storage\_box\_id) | Snapshot storage box id. |
<!-- END_TF_DOCS -->
