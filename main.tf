terraform {
  backend "consul" {}
}

# Create instance
module "mgmthost" {
  source              = "git@git-service.ait.ac.at:sct-cyberrange/terraform-modules/openstack-srv_noportsec.git?ref=v1.4.1"
  hostname            = "mgmthost"
  tag                 = var.tag
  image               = var.image
  flavor              = var.flavor
  volume_size         = var.volume_size
  use_volume          = var.use_volume
  sshkey              = var.sshkey
  network             = var.public_net
  subnet              = var.public_subnet
  host_address_index  = var.public_host_address_index != null ? var.public_host_address_index : null
  additional_networks = var.additional_networks
  userdatafile        = var.userdata_file == null ? "${path.module}/scripts/cloudinit.yml" : var.userdata_file

}

# Assign floating IP

resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.fip_pool
}

resource "openstack_compute_floatingip_associate_v2" "fip" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = module.mgmthost.server.id
}

