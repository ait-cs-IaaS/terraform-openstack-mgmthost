output "mgmthost" {
  value     = module.mgmthost.server
  sensitive = true
}

output "additional_networks" {
  value = module.mgmthost.additional_networks
}

output "floating_ip" {
  value = var.create_fip ? openstack_networking_floatingip_v2.fip[0].address : module.mgmthost.server.network[0].fixed_ip_v4
  sensitive = true
}
