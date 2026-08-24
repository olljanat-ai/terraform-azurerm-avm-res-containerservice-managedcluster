locals {
  is_automatic = var.sku != null && var.sku.name == "Automatic"
  # Whether this module manages the cluster's default agent pool at all - the `agentPoolProfiles`
  # entry in the create request, and the follow-up write straight to the agent pool child resource.
  #
  # A `default_agent_pool` of `null` says it does not, which is what an AKS Automatic cluster wants:
  # AKS runs that cluster's system components on a system node pool it provisions, scales and patches
  # itself, and creates every workload node pool through node autoprovisioning. A default agent pool
  # sent from here is a `systempool` nobody asked for, standing next to the system pool AKS already
  # runs - and because the pool is also written to directly as a child resource, deleting it by hand
  # only makes the next apply put it back.
  #
  # The default is an empty object rather than `null`, so a configuration that says nothing about the
  # default agent pool still gets one, on every SKU, exactly as before.
  manage_default_agent_pool = var.default_agent_pool != null
}
