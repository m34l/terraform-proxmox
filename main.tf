terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"  # Atau versi lain yang stabil
    }
  }
}


provider "proxmox" {
  pm_api_url      = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
}

# Resource VM
resource "proxmox_vm_qemu" "proxmox_vm_master" {

  vmid        = var.vm_id
  name        = var.vm_name
  target_node = var.target_node

  clone      = "ubuntu-2204-cloudinit-template"
  full_clone = true
  # Konfigurasi VM
  cores       = var.vm_cores
  memory      = var.vm_memory
  
  # Konfigurasi Disk
  disk {
    storage = "local-lvm"  # Pastikan ini sesuai dengan nama storage di Proxmox
    size    = var.disk_size
    type    = "scsi"
  }

  # Konfigurasi Network
  network {
    model  = var.network_model
    bridge = var.network_bridge
    tag    = var.network_vlan_tag  # VLAN tag
  }

  # Konfigurasi Boot
  bootdisk = "scsi0"

  # Konfigurasi Cloud-Init
  ipconfig0 = "ip=dhcp"

  # Konfigurasi Cloud-Init untuk SSH
  sshkeys = file(var.ci_ssh_public_key)
  ciuser  = var.ci_user
  cipassword = var.ci_password
}
