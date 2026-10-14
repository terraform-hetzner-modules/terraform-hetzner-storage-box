# Maintenance and upgrade guide

This module starts with Terraform >= 1.7 and `hetznercloud/hcloud ~> 1.70`.
The test matrix covers Terraform 1.7.5/1.16.6 and OpenTofu 1.11.14/1.13.1.
OpenTofu 1.8.8 crashes in its mock value composer when `snapshot_plan` is null. The
[nested-attribute handling in OpenTofu 1.11](https://github.com/opentofu/opentofu/blob/v1.11.0/internal/configs/hcl2shim/mock_value_composer.go)
fixes this engine limitation. Use OpenTofu >= 1.11 for this module's test suite.
These are module compatibility tests; older engines are not necessarily in the provider's own supported test matrix.

## Before upgrading

Back up your root configuration's state and commit its dependency lock file. Update the module version,
run `terraform init -upgrade` (or `tofu init -upgrade`), and review the plan before applying it.
Child module lock files do not constrain a consuming root configuration.
Keep caller-supplied map keys stable to retain resource addresses.
Unknown object properties may be discarded by Terraform's object conversion; check input property names.

## Checks

Run `terraform init -backend=false`, `terraform validate`, and `terraform test` (or equivalent `tofu`
commands). Initialize and validate each example and submodule separately. Tests use mock providers;
no cloud credentials are needed and no real infrastructure is created.
Before release, check creation, a second no-change plan, updates, and teardown in a disposable Hetzner
project. Mocks do not verify live API behavior, quotas, or capacity.

## Provider coverage maintenance

Formr generates the [schema report](SCHEMA.md). With the module initialized,
run `formr schema . -o docs/SCHEMA.md` and `formr check . --report docs/SCHEMA.md`.
Use the same engine and provider selections recorded in the report's provenance.
The default policy checks inventory completeness and unresolved analysis. Strict interface coverage
and exception annotations are not yet implemented, so a passing check does not approve omitted fields.
Provider configuration belongs in the consuming root configuration; IDs and other computed attributes
are provider-managed rather than creation inputs.

Regenerate README inputs/outputs with `terraform-docs -c .github/linters/.terraform-docs.yml .`.

Passwords intentionally have no outputs. All configurable resource fields are exposed through typed
inputs, including nested access settings and snapshot scheduling. Resource defaults are delegated to
the provider where inputs are null. Changing initial SSH keys or location replaces the box.
The snapshot submodule has its own `docs/SCHEMA.md`; generate and check it from that submodule directory.

Formr currently marks the subaccount password as exported because it traces the resource collection
through an output comprehension. The output explicitly selects fields and excludes passwords; a native
Terraform test checks this exclusion. Treat that report entry as a conservative dependency trace.
