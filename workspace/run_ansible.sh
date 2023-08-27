#!/bin/bash

# Install Ansible
yum install -y ansible

# Run the Ansible playbook
ansible-playbook -i ~/ansible_inventory.ini /path/to/setup.yml
