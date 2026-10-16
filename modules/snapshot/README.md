# Hetzner Storage Box Snapshot Terraform module

Manage a manual snapshot of an existing storage box.
Invoke this submodule explicitly to capture a point in time.

## Usage

Put this configuration in `main.tf` and supply `storage_box_id` for the resource to capture.

```hcl
variable "storage_box_id" {
  description = "ID of the existing storage box to snapshot."
  type        = number
}

module "snapshot" {
  source = "terraform-hetzner-modules/storage-box/hetzner//modules/snapshot"

  storage_box_id = var.storage_box_id
  description    = "Before maintenance"
  labels         = { purpose = "maintenance" }
}
```

## Provider configuration

Export your API token as `HCLOUD_TOKEN` and put this in your calling root's `versions.tf`:

```hcl
terraform {
  required_version = ">= 1.7"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.70"
    }
  }
}

provider "hcloud" {}
```

Run `terraform init`, `terraform plan`, and `terraform apply` from the calling root.

## Notes

A snapshot captures a point in time. File changes on the parent do not refresh an existing snapshot.
To capture a new point in time, add another module instance or deliberately replace this resource.
Changing the parent ID replaces the snapshot. Destroying this module deletes its snapshot.
Ensure any required provisioning or application quiescing has completed before creating a snapshot;
Terraform dependencies alone do not guarantee an application-consistent backup.

Snapshot names and the `is_automatic` flag are provider-managed outputs.
Use the parent module's `snapshot_plan` for automatic snapshots and retention.

See the [schema report](docs/SCHEMA.md) for provider coverage and the
[parent module](../../README.md) for examples and contribution guidelines.

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
| [hcloud_storage_box_snapshot.current](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/storage_box_snapshot) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| description | Description of the snapshot. Null uses the provider default. | `string` | `null` | no |
| labels | Labels attached to the snapshot. | `map(string)` | `{}` | no |
| storage\_box\_id | ID of the source Storage Box. Changing this replaces the snapshot. | `number` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| description | Snapshot description. |
| id | Snapshot id. |
| is\_automatic | Snapshot is automatic. |
| labels | Snapshot labels. |
| name | Snapshot name. |
| storage\_box\_id | Snapshot storage box id. |
<!-- END_TF_DOCS -->
