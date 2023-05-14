# Makefile

# Commands are installed, with some exceptions, inside virtualenv so we need to ensure that their are accesibles.
ifndef VIRTUAL_ENV
	$(error VIRTUAL_ENV is not set)
endif
VENV_PATH=${VIRTUAL_ENV}/bin
#
ANSIBLE_PLAYBBOK = ${VENV_PATH}/ansible-playbook
ANSIBLE_GALAXY = ${VENV_PATH}/ansible-galaxy

up: Vagrantfile
	vagrant box update
	vagrant up

galaxy-up: ansible-requirements.yml
	${ANSIBLE_GALAXY} collection install -r ansible-requirements.yml

play: galaxy-up
	${ANSIBLE_PLAYBBOK} playbook.yml

debug: galaxy-up
	${ANSIBLE_PLAYBBOK} playbook.yml -t debug

destroy:
	vagrant destroy -f

build: up play

rebuild: destroy up play