variable "proxmox_api_url" {
  description = "URL API Proxmox"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox API Token ID"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Proxmox API Token Secret"
  type        = string
}

variable "ci_user" {
  description = "Cloud-Init user"
  type        = string
}

variable "ci_password" {
  description = "Cloud-Init password"
  type        = string
}

variable "ci_ssh_public_key" {
  description = "Path to Cloud-Init SSH public key"
  type        = string
}

variable "ci_ssh_private_key" {
  description = "Path to Cloud-Init SSH private key"
  type        = string
}

variable "vm_id" {
  description = "ID of the VM"
  type        = string
}

variable "vm_name" {
  description = "Name of the VM"
  type        = string
}

variable "vm_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
}

variable "vm_memory" {
  description = "Amount of memory (in MB) for the VM"
  type        = number
}

variable "disk_size" {
  description = "Size of the VM disk"
  type        = string
}

variable "network_model" {
  description = "Network model for the VM"
  type        = string
  default     = "virtio"
}

variable "network_bridge" {
  description = "Network bridge for the VM"
  type        = string
}

variable "network_vlan_tag" {
  description = "VLAN tag for the VM network"
  type        = number
}

variable "target_node" {
  description = "Proxmox node where the VM will be deployed"
  type        = string
}

variable "template_id" {
  description = "ID template VM yang akan dikloning"
  type        = string
}

