package terraform

import input as tfplan

allowed_roles = ["loadbalancer", "master", "worker"]

get_role(name) = role {
    parts := split(name, "-")
    role := parts[3]
}

violation[msg] {
    roles := tfplan.variables.vm_roles.value
    expected_total := roles.loadbalancer + roles.master + roles.worker
    
    vm_resources := [res | res := tfplan.resource_changes[_]; res.type == "proxmox_vm_qemu"]
    total_vms := count(vm_resources)
    
    total_vms != expected_total
    
    msg := sprintf("Expected %d VMs, but found %d", [expected_total, total_vms])
}

violation[msg] {
    roles := tfplan.variables.vm_roles.value
    vm_resources := [res | res := tfplan.resource_changes[_]; res.type == "proxmox_vm_qemu"]
    
    role := allowed_roles[_]
    expected := roles[role]
    actual := count([1 | vm := vm_resources[_]; get_role(vm.change.after.name) == role])
    
    expected != actual
    
    msg := sprintf("Mismatch in VM count for role '%s'. Expected: %d, Found: %d", [role, expected, actual])
}

violation[msg] {
    res := tfplan.resource_changes[_]
    res.type == "proxmox_vm_qemu"
    role := get_role(res.change.after.name)
    not array_contains(allowed_roles, role)
    msg := sprintf("Invalid role '%s' for VM '%s'", [role, res.change.after.name])
}

array_contains(arr, elem) {
    arr[_] = elem
}

allow {
    count(violation) == 0
}

result = msg {
    count(violation) > 0
    msg := concat(", ", violation)
} else = msg {
    msg := "Allowed: All checks passed. The Terraform plan for Proxmox VMs is valid."
}

info[msg] {
    res := tfplan.resource_changes[_]
    res.type == "proxmox_vm_qemu"
    role := get_role(res.change.after.name)
    msg := sprintf("VM: Name=%s, Role=%s, Node=%s", [res.change.after.name, role, res.change.after.target_node])
}

info[msg] {
    msg := sprintf("VM Roles: %s", [tfplan.variables.vm_roles.value])
}