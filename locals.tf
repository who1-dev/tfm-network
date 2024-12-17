locals {
  default_tags  = merge(var.default_tags, { "AppRole" : var.app_role, "Environment" : upper(var.env), "Project" : var.namespace })
  name_prefix   = "${var.namespace}-${var.env}"
  remote_states = { for k, v in data.terraform_remote_state.this : k => v.outputs }
}