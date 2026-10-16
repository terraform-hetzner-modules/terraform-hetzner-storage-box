# Full storage box example

Supply the sensitive main `password` and `subaccount_passwords` map with `backups` and `reader` keys.
Optionally supply initial public key contents in `ssh_keys`; changing them later replaces the box.
The example configures every root and nested field, independent writer and read-only account settings,
a weekly automatic snapshot plan, and a manual snapshot through the snapshot submodule.

The schedule is Sunday at 02:30 UTC. For a monthly schedule, set `day_of_week = null` and
`day_of_month = 1`; for a daily schedule, leave both null. Only choose one scheduling alternative.
A manual snapshot captures one point in time and does not update when files change.

Passwords remain in Terraform state. Deletion protection does not prevent destruction through
Terraform: the provider clears it during deletion. Review replacement and destroy plans carefully.

## Running the example

Export `HCLOUD_TOKEN`, supply the inputs described in `variables.tf`, then run:

```shell
terraform init
terraform plan
terraform apply
```

This creates real infrastructure. Review the plan and any deletion protection before cleanup.
See the [module README](../../README.md) for usage and input descriptions.
