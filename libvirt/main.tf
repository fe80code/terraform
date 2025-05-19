terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

# Configure the Libvirt provider
provider "libvirt" {
  uri = "qemu:///system"
}

# Create a base volume for the virtual machines
resource "libvirt_volume" "basevolume" {
  name = "basevolume.qcow2"
  source = var.img_source
}

# Cloud-init configuration
data "template_file" "cloud_init" {
  template = <<EOF
#cloud-config

users:
  - name: ubuntu
    ssh_authorized_keys:
      - ${file("~/.ssh/id_rsa.pub")}
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: sudo
    shell: /bin/bash
    lock_passwd: false

EOF
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  user_data      = data.template_file.cloud_init.rendered
}

# Create virtual machines
resource "libvirt_volume" "volume" {
  count          = var.vm_count
  name           = "${var.hostname_prefix}${format("%02d", count.index + 1)}.qcow2"
  base_volume_id = libvirt_volume.basevolume.id
}

resource "libvirt_domain" "vm" {
  count   = var.vm_count
  name    = "${var.hostname_prefix}${format("%02d", count.index + 1)}"
  running = true
  memory = var.mem_size
  vcpu   = var.cpu_cores
    
  disk {
    volume_id = libvirt_volume.volume[count.index].id
  }

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_name = "default"        
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type      = "spice"
    autoport  = true
    listen_type = "address"
  }
}
