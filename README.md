# Terraform: OpenStack-mgmthost

Creates a management-host that resides in all networks

## Configuration

```
module "mgmthost" {
  source = "git@github.com:ait-cs-IaaS/terraform-openstack-mgmthost.git"
  image_id = openstack_images_image_v2.ubuntu-bionic-amd64.id
  publicnet-id = var.extnet_id
  network_ids = [module.locnet.network_id, module.secnet.network_id, module.internet.network_id]
}
```
