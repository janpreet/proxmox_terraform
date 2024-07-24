# Terraform Proxmox Kubernetes Cluster

Welcome to the Terraform configuration for setting up a Kubernetes cluster on Proxmox VE! This setup is fully parameterized and designed to be flexible. Just provide an external `terraform.tfvars` file during `plan` and `apply` stages, and you're good to go. Also, the Terraform state is stored remotely in an AWS S3 bucket for easy access and collaboration.

## Prerequisites

Before you get started, make sure you have:

- Terraform installed on your local machine.
- Access to a Proxmox VE environment with API credentials.
- AWS credentials configured for state storage.
- SSH keys for accessing the VMs.

## Project Structure

Here's a quick look at the project structure:

```
terraform/
├── main.tf
├── variables.tf
├── backend.tf
├── outputs.tf
├── vm_configuration.tf
├── kubernetes_configuration.tf
├── templates/
│   ├── cloud_init_user_data.yaml
│   ├── haproxy.cfg
│   ├── k8s_worker_env.sh.tpl
│   ├── haproxy_env.sh.tpl
├── scripts/
│   ├── k8s_master_setup.sh
│   ├── k8s_worker_setup.sh
│   ├── haproxy_setup.sh
│   ├── run_k8s_master_setup.sh
│   ├── run_k8s_worker_setup.sh
│   ├── run_haproxy_setup.sh
│   └── k8s_join_command.sh
└── terraform.tfvars
```

## What's Inside

- **`main.tf`**: Configures the Terraform providers and backend.
- **`variables.tf`**: Declares the variables used in the Terraform configuration.
- **`backend.tf`**: Configures the remote state storage in AWS S3.
- **`outputs.tf`**: Defines the outputs for the Terraform run.
- **`vm_configuration.tf`**: Configures the VMs in Proxmox.
- **`kubernetes_configuration.tf`**: Configures the Kubernetes cluster setup.
- **`templates/`**: Contains cloud-init and environment variable templates.
- **`scripts/`**: Contains the scripts used to set up Kubernetes and HAProxy.
- **`terraform.tfvars`**: Example file for variable values (to be created externally).

## Getting Started

1. **Clone or Download the Repo**

   First, clone or download this repository to your local machine.

2. **Navigate to the Directory**

   Open a terminal and navigate to the directory where your Terraform files are located.

3. **Create Your `terraform.tfvars` File**

   Create a `terraform.tfvars` file in the same directory with the following content, replacing the placeholder values with your actual values:

   ```hcl
    aws_region               = "aws-region"
    pm_api_url               = "https://pm-url/api2/json"
    pm_user                  = "your-proxmox-user"
    pm_password              = "your-proxmox-password"
    vm_roles = {
    master       = 2
    worker       = 3
    loadbalancer = 1
    }
    vm_template              = "100"
    vm_cpu                   = 2
    vm_memory                = 2048
    vm_disk_size             = "10G"
    vm_storage               = "local-lvm"
    vm_network_bridge        = "vmbr0"
    vm_network_model         = "virtio"
    proxmox_nodes            = ["node1", "node2", "node3"]
    s3_bucket                = "aws-s3-bucket"
    s3_key                   = "path/to/your/key"
    ssh_public_key_content   = "your-ssh-public-key-content"
    ssh_private_key          = "path/to/your/ssh_private_key"
    ssh_user                 = "ubuntu"
    cloud_init_user_data_file = "templates/cloud_init_user_data.yaml"
    k8s_master_setup_script  = "scripts/k8s_master_setup.sh"
    k8s_worker_setup_script  = "scripts/k8s_worker_setup.sh"
    haproxy_setup_script     = "scripts/haproxy_setup.sh"
    haproxy_config_file      = "templates/haproxy.cfg"
    generate_kubeadm_token_script = "scripts/generate_kubeadm_token.sh"
   ```

4. **Initialize Terraform**

   Run the following command to initialize Terraform. This will download the required providers and set up the backend.

   ```sh
   terraform init
   ```

5. **Plan the Terraform Configuration**

   Before applying the configuration, it's a good idea to see what changes will be made. Run the following command to generate an execution plan:

   ```sh
   terraform plan -var-file="terraform.tfvars"
   ```

6. **Apply the Terraform Configuration**

   Now, apply the Terraform configuration to create the VMs and set up the Kubernetes cluster:

   ```sh
   terraform apply -var-file="terraform.tfvars"
   ```

## Backend Configuration

The Terraform state is stored remotely in an AWS S3 bucket. The `backend.tf` file configures the remote state storage:

```hcl
terraform {
  backend "s3" {
    bucket = var.s3_bucket
    key    = var.s3_key
    region = var.aws_region
  }
}
```

## Distributing VMs Across Nodes

The code distributes the VMs evenly across the nodes in your Proxmox VE cluster. By providing a list of Proxmox nodes in the `terraform.tfvars` file, the configuration ensures that the VMs are balanced across the specified nodes, enhancing the distribution of resources and improving performance.

## Summary

- **Initialize Terraform**: `terraform init`
- **Create `terraform.tfvars` File**: Populate with your actual values.
- **Plan Configuration**: `terraform plan -var-file="terraform.tfvars"`
- **Apply Configuration**: `terraform apply -var-file="terraform.tfvars"`

<<<<<<< HEAD
This setup will create a Kubernetes cluster on Proxmox VMs, with the Terraform state stored remotely in an AWS S3 bucket. Enjoy your new Kubernetes cluster!
=======
This setup will create a Kubernetes cluster on Proxmox VMs, with the Terraform state stored remotely in an AWS S3 bucket. Enjoy your new Kubernetes cluster!
>>>>>>> origin/main
