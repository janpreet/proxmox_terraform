variable "pm_api_url" {
  description = "The URL of the Proxmox cluster."
  type        = string
}

variable "pm_user" {
  description = "The Proxmox user."
  type        = string
}

variable "pm_password" {
  description = "The Proxmox user password."
  type        = string
}

variable "vm_roles" {
  description = "Map of VM roles and their counts."
  type        = map(number)
  default = {
    master       = 2
    worker       = 3
    loadbalancer = 1
  }
}

variable "vm_name_prefix" {
  description = "Prefix for the VM names."
  type        = string
  default     = "tf-vm"
}

variable "vm_template" {
  description = "The template to use for the VMs."
  type        = string
}

variable "vm_cpu" {
  description = "Number of CPUs for the VMs."
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Memory size for the VMs (in MB)."
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Disk size for the VMs."
  type        = string
  default     = "10G"
}

variable "vm_storage" {
  description = "Storage type for the VMs."
  type        = string
  default     = "local-lvm"
}

variable "vm_network_model" {
  description = "Network model for the VMs."
  type        = string
  default     = "virtio"
}

variable "vm_network_bridge" {
  description = "Network bridge for the VMs."
  type        = string
  default     = "vmbr0"
}

variable "proxmox_nodes" {
  description = "List of Proxmox nodes to distribute the VMs across."
  type        = list(string)
}

variable "aws_region" {
  description = "AWS region for the S3 bucket."
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket" {
  description = "Name of the S3 bucket for storing the Terraform state."
  type        = string
}

variable "s3_key" {
  description = "Path to the state file inside the S3 bucket."
  type        = string
}

variable "ssh_public_key_content" {
  description = "SSH public key content for the VMs."
  type        = string
}

variable "cloud_init_user_data_file" {
  description = "Path to the cloud-init user data file."
  type        = string
  default     = "templates/cloud_init_user_data.yaml"
}

variable "ssh_private_key" {
  description = "Path to the SSH private key for accessing the VMs."
  type        = string
}

variable "ssh_user" {
  description = "SSH user for accessing the VMs."
  type        = string
  default     = "ubuntu"
}

variable "k8s_master_setup_script" {
  description = "Path to the Kubernetes master setup script."
  type        = string
}

variable "k8s_worker_setup_script" {
  description = "Path to the Kubernetes worker setup script."
  type        = string
}

variable "haproxy_setup_script" {
  description = "Path to the HAProxy setup script."
  type        = string
}

variable "haproxy_config_file" {
  description = "Path to the HAProxy configuration file."
  type        = string
  default     = "templates/haproxy.cfg"
}
