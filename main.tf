provider "openstack" {
}

terraform {
  backend "consul" {}
}


resource "openstack_networking_secgroup_v2" "mgmthost-sg" {
  name        = "mgmthost-sg"
  description = "Security-Group for the mgmthost"
}

resource "openstack_networking_secgroup_rule_v2" "mgmthost-rule-01" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.mgmthost-sg.id}"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/scripts/cloudinit.yml")}"
}

data "template_cloudinit_config" "cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.user_data.rendered
  }
}

# Create instance
#
resource "openstack_compute_instance_v2" "mgmthost" {
  name               = "mgmthost"
  flavor_name        = "${var.flavor}"
  key_pair           = "${var.sshkey}"

  metadata = {
    groups = "management"
  }

  user_data = data.template_cloudinit_config.cloudinit.rendered

  block_device {
    uuid                  = "${var.image_id}"
    source_type           = "image"
    volume_size           = 10
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  security_groups = ["mgmthost-sg"]

  network {
     uuid = "${var.publicnet-id}"
  }
}


resource "openstack_compute_interface_attach_v2" "net" {
   count = "${length(var.network_ids)}"
   instance_id = "${openstack_compute_instance_v2.mgmthost.id}"
   network_id = "${element(var.network_ids,count.index)}"
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "${var.fip_pool}"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.mgmthost.id}"
}

