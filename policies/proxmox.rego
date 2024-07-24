package terraform.kubernetes

deny[{"msg": msg}] {
    contains_sensitive_data(input.resource_changes)
    msg := "Sensitive data found in configuration. Please use variables for sensitive data."
}

contains_sensitive_data(resource_changes) {
    resource := resource_changes[_]
    resource.change.after.pm_password
}

deny[{"msg": msg}] {
    count(input.configuration.root_module.variables.proxmox_nodes.default) < 2
    msg := "VMs must be distributed across at least two nodes."
}

deny[{"msg": msg}] {
    input.configuration.root_module.variables.vm_template.default != "100"
    msg := "VM template must be set to 100."
}

deny[{"msg": msg}] {
    input.configuration.root_module.variables.vm_cpu.default > 4
    msg := "VM CPU must not exceed 4 cores."
}

deny[{"msg": msg}] {
    input.configuration.root_module.variables.vm_memory.default > 8192
    msg := "VM memory must not exceed 8192 MB."
}

deny[{"msg": msg}] {
    not input.configuration.root_module.variables.s3_bucket.default
    msg := "S3 bucket for remote state storage must be specified."
}

deny[{"msg": msg}] {
    not input.configuration.root_module.variables.s3_key.default
    msg := "S3 key for remote state storage must be specified."
}

deny[{"msg": msg}] {
    not input.configuration.provider_config.aws.expressions.region.references[0]
    msg := "AWS region for remote state storage must be specified."
}

deny[{"msg": msg}] {
    not input.configuration.root_module.variables.ssh_public_key_content.default
    msg := "SSH public key content must be specified."
}

deny[{"msg": msg}] {
    input.configuration.root_module.variables.pm_password.default
    msg := "Plain-text secrets must not be used in the configuration. Use environment variables instead."
}
