mock_provider "hcloud" {}

run "computed_sensitive_passwords_are_plannable" {
  command = plan
  module { source = "./tests/setup" }
  assert {
    condition     = keys(output.subaccount_ids) == ["backups"]
    error_message = "Unknown passwords and parent IDs must not determine subaccount addresses."
  }
}
