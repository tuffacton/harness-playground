# Manage Harness Resources with Crossplane

The Harness Terraform provider (http://github.com/harness-io/terraform-provider-harness) is a great way to manage Harness resources with code. But what if you want to manage Harness resources with as Kubernetes CRDs? That's where Crossplane comes in, combined with the Terraform Provider for Crossplane (https://marketplace.upbound.io/providers/upbound/provider-terraform/v0.17.0).

## Installing Crossplane
This guide was made 08/28/2024 and assumes you are using the following setup steps for Crossplane on any standard K8s Cluster (influenced by documentation for https://marketplace.upbound.io/providers/upbound/provider-terraform/v0.17.0)

1. Install the Up command-line tool from upbound
```
curl -sL "https://cli.upbound.io" | sh
mv up /usr/local/bin/
```
2. Install the Universal Crossplane CRDs
```
up uxp install
```
3. Validate that you have Crossplane installed correctly with `kubectl get pods -n upbound-system`
```
$ kubectl get pods -n upbound-system
NAME                                       READY   STATUS    RESTARTS      AGE
crossplane-ddc974f67-kp6t2                 1/1     Running   0             93s
crossplane-rbac-manager-7978c5f8df-8w8sg   1/1     Running   0             93s
upbound-bootstrapper-754f65bd-h92tm        1/1     Running   0             93s
xgql-8fb949dcf-pxn4z                       1/1     Running   3 (52s ago)   93s
```

## Install the Harness Provider and Provider Config
1. Install the Terraform Crosslane Provider (https://marketplace.upbound.io/providers/upbound/provider-terraform/v0.17.0):
```sh
kubectl apply -f provider.yaml

# Validate
kubectl get provider
NAME                                   AGE
providerconfig.tf.upbound.io/harness   16m

NAME                                                                     AGE    CONFIG-NAME   RESOURCE-KIND   RESOURCE-NAME
providerconfigusage.tf.upbound.io/11f24fc3-cc44-4c59-91a8-fae24e17b6fc   8m4s   harness       Workspace       harness-project
```
2. Create a `terraform.tfvars.json` with credentials for the Harness terraform provider (https://registry.terraform.io/providers/harness/harness/latest/docs) replacing with your actual gateway `endpoint`, `account_id`, and `platform_api_key` from a PAT or SAT (https://developer.harness.io/docs/platform/automation/api/add-and-manage-api-keys/):
```json
{
    "endpoint": "https://app.harness.io/gateway",
    "account_id":"XXXXXXXXXXXXXXXXXXX",
    "platform_api_key": "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
}
```
3. Create a secret from the `terraform.tfvars.json` file using the following command:
```sh
kubectl create secret generic harness-credentials -n upbound-system --from-file=credentials=terraform.tfvars.json
```
4. Create the `harness` crossplane ProviderConfig
```sh
kubectl apply -f providerconfig-harness.yaml

# Validate
kubectl get providerconfig
NAME      AGE
harness   17m
```

## Creating Harness Resources
In the provided example, we simply create a project with the identifier `test_project` in the `default` organization. The `default` organization is one that is available in pretty much all new Harness accounts, but feel free to modify the organization to match your specific setup.
```sh
kubectl apply -f harness-project.yaml

# Validate
kubectl get workspace harness-project 
NAME              SYNCED   READY   AGE
harness-project   True     True    9m28s
```

## Deleting Harness Resources
Deletion follows the same deletion policy as other Crossplane resources (https://docs.crossplane.io/latest/concepts/managed-resources/#deletionpolicy) so unless you modify the default `deletionPolicy: Delete` applied to most workspaces then the resource will delete when you do a `kubectl delete`.

## Troubleshooting
As these are standard K8S CRDs, troubleshooting is as simple as `kubectl describe` for any resources, where you can see any event details that may be preventing a resource from standing up shutting down.