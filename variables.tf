variable "image" {
  type        = string
  description = "name of the image to boot the hosts from"
}

variable "flavor" {
  type        = string
  description = "instance flavor for the mgmthost"
  default     = "m1.small"
}

variable "volume_size" {
  type        = string
  description = "volume_size"
  default     = 10
}

variable "sshkey" {
  type        = string
  description = "ssh key for the mgmthost"
  default     = "cyberrange-key"
}

variable "public_net" {
  type        = string
  description = "The public network the management host should be connected to"
}

variable "public_subnet" {
  type        = string
  description = "The public subnet the management host should be connected to"
}

variable "public_host_address_index" {
  type        = number
  description = "Optional fixed ip address within the public net"
  default     = null
}
variable "additional_networks" {
  type = map(
    object({
      network            = string
      subnet             = string
      host_address_index = number
    })
  )
  description = "Additional networks the management host should be connected to"
  default     = {}
}

variable "fip_pool" {
  type        = string
  description = "Floating IP pool"
  default     = "provider-cyberrange-207"
}


variable "use_volume" {
  type        = bool
  description = "If the a volume or a local file should be used for storage"
  default     = false
}