#!/bin/bash

echo "Creating Terraform files..."

mkdir -p terraform
cat << 'EOF' > terraform/main.tf
provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "controller" {
  ami           = "ami-0fd05997b4dff7aac"
  instance_type = "t2.micro"

  tags = {
    Name = "controller-node"
  }
}

resource "aws_instance" "managed" {
  ami           = "ami-0fd05997b4dff7aac"
  instance_type = "t2.micro"

  tags = {
    Name = "managed-node"
  }
}
EOF

cat << 'EOF' > terraform/outputs.tf
output "controller_public_ip" {
  description = "Public IP of controller node"
  value       = aws_instance.controller.public_ip
}

output "managed_public_ip" {
  description = "Public IP of managed node"
  value       = aws_instance.managed.public_ip
}
EOF

cat << 'EOF' > terraform/variables.tf
# No variables used in this simple example
EOF


echo "Creating Ansible files..."

mkdir -p ansible
cat << 'EOF' > ansible/inventory.ini
[controller]
controller-node ansible_host=<controller_public_ip> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/mykey.pem

[managed]
managed-node ansible_host=<managed_public_ip> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/mykey.pem
EOF

cat << 'EOF' > ansible/playbook.yml
---
- name: Basic setup on Managed Node
  hosts: managed
  become: yes
  tasks:
    - name: Install Apache
      apt:
        name: apache2
        state: present
        update_cache: yes
EOF

echo "Project structure created successfully!"
