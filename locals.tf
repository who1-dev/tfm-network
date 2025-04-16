locals {
  default_tags  = merge(var.default_tags, { "AppRole" : var.app_role, "Environment" : upper(var.env), "Project" : var.namespace })
  name_prefix   = "${var.namespace}-${var.env}"
  remote_states = { for k, v in data.terraform_remote_state.this : k => v.outputs }


  # Will be used for network isolation(e.g: malware attack)
  pub_sub_assoc = length(var.filter_public_route_table_association) == 0 ? var.public_subnets : {
    for k, v in var.public_subnets : k => v if !contains(var.filter_public_route_table_association, k)
  }

  # Will be used for network isolation(e.g: malware attack)
  prv_sub_assoc = length(var.filter_private_route_table_association) == 0 ? var.private_subnets : {
    for k, v in var.private_subnets : k => v if !contains(var.filter_private_route_table_association, k)
  }
}