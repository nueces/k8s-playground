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

The main idea behind this project is to create a playground to learn Kubernetes.

# Prerequisites
* Install pyenv
* Install vagrant
* Install virtualbox
* Create an ssh key to use with the virtual machines.

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

### CICD
* test support of multiples vagrant box distributions, like ubuntu/focal64, etc.

# Instructions

## Using make

```shell
Usage: make <target>  [one or more targets separated by spaces and in the order that their would executed]

 The following targets are available: 

	help
			Show this help.
	all
			Run init, up, and play targets.
	init
			Run pip-install, and galaxy-up targets.
	pip-install
			Install python dependecies using pip.
	pip-upgrade
			Upgrade python dependecies using pip.
			Ignore pinning versions in the requirements.txt file.
	pip-uninstall
			Uninstall python dependencies using pip.
	up
			Deploy Vagrant boxes.
	galaxy-up
			Install ansible modules using ansible-galaxy.
	play
			Run ansible-playbook.
	debug
			Run ansible-playbook, ejecute only task tagged as 'debug'.
	destroy
			Destroy Vagrant boxes.
	build
			Run up, and play targets.
	rebuild
			Run destroy, up, and play targets.

```

## Manual steps

Bootstrap virtualenv
```shell
pyenv virtualenv k8s-playground
```

Activate virtualenv
```shell
pyenv activate k8s-playground
```

Install Ansible and python dependencies
```shell
pip install -r requirements.txt
```

Deploy Vagrant machines
```shell
Vagrant up
```

Cluster provisioning
```shell
ansible-playbook playbook.yml
```

# Notes:
[^1]: On Linux, macOS and Solaris Oracle VM VirtualBox will only allow IP addresses in 192.168.56.0/21 range to be assigned to host-only adapters https://www.virtualbox.org/manual/ch06.html#network_hostonly
[^2]: In releases older than Debian 12 and Ubuntu 22.04, `/etc/apt/keyrings` does not exist by default. https://wiki.debian.org/DebianRepository/UseThirdParty