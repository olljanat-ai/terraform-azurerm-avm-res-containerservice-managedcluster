locals {
  is_automatic = var.sku != null && var.sku.name == "Automatic"
  # Whether this module manages the cluster's default agent pool at all - the `agentPoolProfiles`
  # entry in the create request, and the follow-up write straight to the agent pool child resource.
  #
  # AKS Automatic runs its system components on a managed system node pool that AKS provisions,
  # scales and patches by itself, and creates every workload node pool through node autoprovisioning.
  # Microsoft documents that an Automatic cluster cannot be created without one, and the Azure CLI
  # strips the agent pool configuration out of the create request for that SKU. A default agent pool
  # sent from here is therefore a `systempool` nobody asked for, sitting next to the system pool AKS
  # already runs - and because the pool is also written to directly as a child resource, deleting it
  # by hand only makes the next apply put it back.
  #
  # So an Automatic cluster manages no default agent pool unless `default_agent_pool_enabled` says
  # otherwise, and every other SKU still does.
  manage_default_agent_pool = var.default_agent_pool_enabled != null ? var.default_agent_pool_enabled : !local.is_automatic
}
