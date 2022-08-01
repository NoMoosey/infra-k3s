resource "proxmox_vm_qemu" "moose-k3s-master" {
  count = 1
  name        = "moose-k3s-master-0${count.index + 1}"
  target_node = "bender"
  clone = "ubuntu-cloud-bender"

  sockets = 1
  cores = 3
  memory = 4096

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn5k5xqBqVg9HqNwOq/TjtvIUc+/vugkDh6PVeI7FYg joe@Joes-MacBook-Pro.local"

  nameserver = "10.1.2.120"
  ipconfig0 = "gw=10.1.2.1,ip=10.1.2.16${count.index + 1}/24"

  disk {
    type         = "virtio"
    storage      = "fast-thin"
    size         = "100G"
  }
}

resource "proxmox_vm_qemu" "moose-k3s-worker" {
  count = 3
  name        = "moose-k3s-worker-0${count.index + 1}"
  target_node = "bender"
  clone = "ubuntu-cloud-bender"

  sockets = 5
  cores = 1
  memory = 10240

  sshkeys = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEn5k5xqBqVg9HqNwOq/TjtvIUc+/vugkDh6PVeI7FYg joe@Joes-MacBook-Pro.local"

  nameserver = "10.1.2.120"
  ipconfig0 = "gw=10.1.2.1,ip=10.1.2.17${count.index + 1}/24"

  disk {
    type         = "virtio"
    storage      = "fast-thin"
    size         = "200G"
  }
#   disk {
#     type         = "virtio"
#     storage      = "baymax-fast"
#     size         = "200G"
#   }
}

locals {
  master_ips = [for vm in proxmox_vm_qemu.moose-k3s-master : split("/", substr(vm.ipconfig0, 15, 18))[0]]
  worker_ips = [for vm in proxmox_vm_qemu.moose-k3s-worker : split("/", substr(vm.ipconfig0, 15, 18))[0]]
}

output master-ip-test {
  # value       = join(", ", [for ip in local.master_ips : ip])
  value       = join("\n", local.master_ips)
}
output worker-ip-test {
  # value       = join(", ", [for ip in local.master_ips : ip])
  value       = join("\n", local.worker_ips)
}

resource "local_file" "ansible_inventory-masters" {
  filename = "../ansible/terraform_inventory/masters.ini"
  content = join("\n", local.master_ips)
}

resource "local_file" "ansible_inventory-workers" {
  filename = "../ansible/terraform_inventory/workers.ini"
  content = join("\n", local.worker_ips)
}
