locals {
  vm_roles_list = flatten([
    for role, count in var.vm_roles : [
      for i in range(count) : role
    ]
  ])
}

resource "proxmox_vm_qemu" "vm" {
  count = length(local.vm_roles_list)

  name        = "${var.vm_name_prefix}-${count.index}-${local.vm_roles_list[count.index]}"
  target_node = element(var.proxmox_nodes, count.index % length(var.proxmox_nodes))
  clone       = var.vm_template

  os_type  = "cloud-init"
  cores    = var.vm_cpu
  memory   = var.vm_memory
  scsihw   = "virtio-scsi-pci"
  agent    = 1
  cicustom = "user=local:snippets/cloud-init-user-data-${count.index}.yaml"

  network {
    model  = var.vm_network_model
    bridge = var.vm_network_bridge
  }

  disk {
    size    = var.vm_disk_size
    type    = "scsi"
    storage = var.vm_storage
  }

  lifecycle {
    ignore_changes = [
      network,
      agent,
      cicustom,
    ]
  }
}

resource "local_file" "cloud_init_user_data" {
  count = length(local.vm_roles_list)
  content = templatefile("${path.module}/${var.cloud_init_user_data_file}", {
    ssh_public_key_content = var.ssh_public_key_content
  })
  filename = "${path.module}/local/cloud-init-user-data-${count.index}.yaml"
}
