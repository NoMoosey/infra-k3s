resource "proxmox_vm_qemu" "moose-k3s-master-01" {
  name        = "moose-k3s-master-01"
  target_node = "baymax"
  clone = "ubuntu-cloud-shared-baymax"

  sockets = 2
  cores = 2
  memory = 4096

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn5k5xqBqVg9HqNwOq/TjtvIUc+/vugkDh6PVeI7FYg joe@Joes-MacBook-Pro.local"

  nameserver = "10.1.2.120"
  ipconfig0 = "gw=10.1.2.1,ip=10.1.2.161/24"

  disk {
    type         = "virtio"
    storage      = "baymax-fast"
    size         = "100G"
  }
}

resource "proxmox_vm_qemu" "moose-k3s-master-02" {
  name        = "moose-k3s-master-02"
  target_node = "bender"
  clone = "ubuntu-cloud-bender"

  sockets = 2
  cores = 2
  memory = 4096

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn5k5xqBqVg9HqNwOq/TjtvIUc+/vugkDh6PVeI7FYg joe@Joes-MacBook-Pro.local"

  nameserver = "10.1.2.120"
  ipconfig0 = "gw=10.1.2.1,ip=10.1.2.162/24"

  disk {
    type         = "virtio"
    storage      = "fast-thin"
    size         = "100G"
  }
}

resource "proxmox_vm_qemu" "moose-k3s-master-03" {
  name        = "moose-k3s-master-03"
  target_node = "prox01"
  clone = "ubuntu-cloud-shared-prox01"

  sockets = 1
  cores = 2
  memory = 2048

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn5k5xqBqVg9HqNwOq/TjtvIUc+/vugkDh6PVeI7FYg joe@Joes-MacBook-Pro.local"

  nameserver = "10.1.2.120"
  ipconfig0 = "gw=10.1.2.1,ip=10.1.2.163/24"

  disk {
    type         = "virtio"
    storage      = "local-lvm"
    size         = "100G"
  }
}

resource "proxmox_vm_qemu" "moose-k3s-worker-01" {
  name        = "moose-k3s-worker-01"
  target_node = "baymax"
  clone = "ubuntu-cloud-shared-baymax"

  sockets = 2
  cores = 10
  memory = 20480

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn5k5xqBqVg9HqNwOq/TjtvIUc+/vugkDh6PVeI7FYg joe@Joes-MacBook-Pro.local"

  nameserver = "10.1.2.120"
  ipconfig0 = "gw=10.1.2.1,ip=10.1.2.171/24"

  disk {
    type         = "virtio"
    storage      = "baymax-fast"
    size         = "200G"
  }
}

resource "proxmox_vm_qemu" "moose-k3s-worker-02" {
  name        = "moose-k3s-worker-02"
  target_node = "bender"
  clone = "ubuntu-cloud-bender"

  sockets = 2
  cores = 6
  memory = 28610

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn5k5xqBqVg9HqNwOq/TjtvIUc+/vugkDh6PVeI7FYg joe@Joes-MacBook-Pro.local"

  nameserver = "10.1.2.120"
  ipconfig0 = "gw=10.1.2.1,ip=10.1.2.172/24"

  disk {
    type         = "virtio"
    storage      = "fast-thin"
    size         = "200G"
  }
}

resource "proxmox_vm_qemu" "moose-k3s-worker-03" {
  name        = "moose-k3s-worker-03"
  target_node = "prox01"
  clone = "ubuntu-cloud-shared-prox01"

  sockets = 1
  cores = 4
  memory = 4096

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn5k5xqBqVg9HqNwOq/TjtvIUc+/vugkDh6PVeI7FYg joe@Joes-MacBook-Pro.local"

  nameserver = "10.1.2.120"
  ipconfig0 = "gw=10.1.2.1,ip=10.1.2.173/24"

  disk {
    type         = "virtio"
    storage      = "local-lvm"
    size         = "200G"
  }
}


# locals {
#   master_ips = [for vm in proxmox_vm_qemu.moose-k3s-master : split("/", substr(vm.ipconfig0, 15, 18))[0]]
#   worker_ips = [for vm in proxmox_vm_qemu.moose-k3s-worker : split("/", substr(vm.ipconfig0, 15, 18))[0]]
# }

# output master-ip-test {
#   # value       = join(", ", [for ip in local.master_ips : ip])
#   value       = join("\n", local.master_ips)
# }
# output worker-ip-test {
#   # value       = join(", ", [for ip in local.master_ips : ip])
#   value       = join("\n", local.worker_ips)
# }

# resource "local_file" "ansible_inventory-masters" {
#   filename = "../ansible/terraform_inventory/masters.ini"
#   content = join("\n", local.master_ips)
# }

# resource "local_file" "ansible_inventory-workers" {
#   filename = "../ansible/terraform_inventory/workers.ini"
#   content = join("\n", local.worker_ips)
# }
