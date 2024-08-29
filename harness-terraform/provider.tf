terraform {
    # // Modules _must_ use remote state. The provider does not persist state.
    # backend "kubernetes" {
    # secret_suffix = "providerconfig-default"
    # namespace = "upbound-system"
    # in_cluster_config = true
    # }
    required_providers {
    harness = {
        source = "harness/harness"
        version = "0.32.5"
    }
    }
}

# variable "endpoint" {
#     type = string
#     description= "The API endpoint for Harness, typically https://app.harness.io/gateway"
# }

# variable "account_id" {
#     type = string
#     description = "The unique identifier for your Harness account"
# }

# variable "platform_api_key" {
#     type = string
#     description = "The API (PAT or SAT) key for accessing the Harness platform https://developer.harness.io/docs/platform/automation/api/add-and-manage-api-keys/"
# }

// Use TFVARS or secrets instead!
provider "harness" {
    endpoint = "https://app.harness.io/gateway"
    account_id = "XXXXXXXXXXXXXXXXX"
    platform_api_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}