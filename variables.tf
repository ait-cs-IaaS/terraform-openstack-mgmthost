variable "image_id" {
	type = string
	description = "image-id to boot the mgmthost from"
}

variable "flavor" {
	type = string
	description = "instance flavor for the mgmthost"
        default = "m1.small"
}

variable "sshkey" {
	type = string
        description = "ssh key for the mgmthost"
	default = "cyberrange-key"
}

variable "publicnet-id" {
	type = string
	description = "Public network"
}

variable "network_ids" {
	type = list(string)
	description = "List of network ids to connect the mgmthost to"
}

variable "fip_pool" {
	type = string
	description = "Floating IP pool"
	default = "provider-cyberrange-207"
}
