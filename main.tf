# terraform {
#   backend "consul" {}
# }

# Create instance
module "mgmthost" {
  source = "git@git-service.ait.ac.at:sct-cyberrange/terraform-modules/openstack-srv_noportsec.git?ref=v1.2.1" 
  hostname = "mgmthost"
	tag = "management"
	image = var.image
	flavor = var.flavor
  volume_size = var.volume_size 
	sshkey = var.sshkey
	network = var.public_net
	subnet = var.public_subnet
  ip_address = var.public_ip_address != null ? var.public_ip_address : null
  additional_networks = var.additional_networks
	userdatafile = "${path.module}/scripts/cloudinit.yml"
}

# Assign floating IP

resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.fip_pool
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = module.mgmthost.server.id
}

