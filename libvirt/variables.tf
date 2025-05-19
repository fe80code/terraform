variable "hostname_prefix" {
    description = "Prefix for the hostname of the virtual machines"
    type = string
    default = "vm"
}

variable "vm_count" {
    description = "Number of VMs to create"
    type        = number
    default     = 1
}

variable "img_source" {
    description = "Ubuntu 24.04 LTS Cloud Image"
    default = "https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img"
}

variable "img_format" {
    description = "QCow2 Bootable disk image"
    default = "qcow2"
    type = string
}

variable "mem_size" {
    description = "Amount of RAM (in MiB) for the virtual machine"
    type        = string
    default     = "4096"
}

variable "cpu_cores" {
    description = "Number of CPU cores for the virtual machine"
    type        = number
    default     = 4
}
