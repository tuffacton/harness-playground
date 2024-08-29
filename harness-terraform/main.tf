resource "harness_platform_project" "test" {
    identifier = "test_project"
    name       = "Test Project"
    // This can be modified but for now we'll use the default available in all new Harness accounts
    org_id     = "default"
    color      = "#0063F7"
}