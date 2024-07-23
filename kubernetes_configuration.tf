resource "null_resource" "k8s_master" {
  count = var.vm_roles.master

  provisioner "file" {
    source      = "${path.module}/scripts/k8s_master_setup.sh"
    destination = "/tmp/k8s_master_setup.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, count.index)
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/run_k8s_master_setup.sh"
    destination = "/tmp/run_k8s_master_setup.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, count.index)
    }
  }

  provisioner "remote-exec" {
    script = "/tmp/run_k8s_master_setup.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, count.index)
    }
  }

  triggers = {
    join_command = "${timestamp()}"
  }

  depends_on = [proxmox_vm_qemu.vm]
}

resource "null_resource" "k8s_worker" {
  count = var.vm_roles.worker

  provisioner "file" {
    source      = "${path.module}/scripts/k8s_join_command.sh"
    destination = "/tmp/k8s_join_command.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, count.index + var.vm_roles.master)
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/run_k8s_worker_setup.sh"
    destination = "/tmp/run_k8s_worker_setup.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, count.index + var.vm_roles.master)
    }
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/k8s_worker_env.sh.tpl", {
      master_ip       = element(proxmox_vm_qemu.vm.*.network.0.ip, 0),
      ssh_private_key = file(var.ssh_private_key),
      ssh_user        = var.ssh_user
    })
    destination = "/tmp/k8s_worker_env.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, count.index + var.vm_roles.master)
    }
  }

  provisioner "remote-exec" {
    script = "/tmp/run_k8s_worker_setup.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, count.index + var.vm_roles.master)
    }
  }

  depends_on = [null_resource.k8s_master]
}

resource "null_resource" "k8s_loadbalancer" {
  provisioner "file" {
    source      = "${path.module}/scripts/haproxy_setup.sh"
    destination = "/tmp/haproxy_setup.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, var.vm_roles.master + var.vm_roles.worker)
    }
  }

  provisioner "file" {
    source      = "${path.module}/scripts/run_haproxy_setup.sh"
    destination = "/tmp/run_haproxy_setup.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, var.vm_roles.master + var.vm_roles.worker)
    }
  }

  provisioner "file" {
    content = templatefile("${path.module}/templates/haproxy_env.sh.tpl", {
      master1_ip            = element(proxmox_vm_qemu.vm.*.network.0.ip, 0),
      master2_ip            = element(proxmox_vm_qemu.vm.*.network.0.ip, 1),
      haproxy_template_file = "${path.module}/${var.haproxy_config_file}"
    })
    destination = "/tmp/haproxy_env.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, var.vm_roles.master + var.vm_roles.worker)
    }
  }

  provisioner "remote-exec" {
    script = "/tmp/run_haproxy_setup.sh"
    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.ssh_private_key)
      host        = element(proxmox_vm_qemu.vm.*.network.0.ip, var.vm_roles.master + var.vm_roles.worker)
    }
  }

  depends_on = [null_resource.k8s_master, null_resource.k8s_worker]
}
