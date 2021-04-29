output "mgmthost" {
  value     = module.mgmthost.server
  sensitive = true
}

output "additional_networks" {
  value = module.mgmthost.additional_networks
}

output "floating_ip" {
  value = openstack_networking_floatingip_v2.fip.address
}
