# Kubernetes cluster


This repository contains the structure to deploy and configure a Kubernetes custer running on virtualbox machines using
Vagrant, Ansible, Pyenv+Virtualenv and other tools.

# Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Goals](#Goals)
- [TODO](#todo)
- [Instructions](#Instructions)

# Overview

The main idea behind this project is to create a playground to learn
Kubernetes.

# Prerequisites
* Install pyenv
* Install vagrant
* Install virtualbox
* Create a ssh key to use with the virtual machines.

# Goals
* Use the Ansible inventory as single source of truth to define all the infrastructure.

### Vagrant
* Deploy the virtual machines reading the configuration from the Ansible inventory.yml file.

The private IP range 192.168.15.0/24 was selected due to virtualbox limitations [^1].

### Ansible
* Configure the SO in virtual machines.
* Install and configure the Kubernetes cluster.

### Pyenv + Virtualenv
* Install Ansible and any other python dependency in and isolated virtual environment in the host machine.

# TODO

### Vagrant
* Add support for KVM.

### Ansible
* Use ansible Vault.


# Instructions

Bootstrap virtualenv
```shell
pyenv virtualenv k8s-playground
```

Install Ansible and python dependencies
```shell
pip install -r requirements.txt
```

Deploy Vagrant machines
```shell
Vagrant up
```


# Notes:
[^1]: On Linux, macOS and Solaris Oracle VM VirtualBox will only allow IP addresses in 192.168.56.0/21 range to be assigned to host-only adapters https://www.virtualbox.org/manual/ch06.html#network_hostonly