# Makefile
.DEFAULT_GOAL:=help

### Commands are installed, with some exceptions, inside virtualenv so we need to ensure that their are accesibles.
ifndef VIRTUAL_ENV
	$(error VIRTUAL_ENV is not set, please activate the environment before calling make)
	#TODO: Include the usage message when there is an error. I need more make foo.
	#$@(usage)
endif

define usage
	# The sed command use the {#}\2 to avoid using two consecutive #
	@echo "\nUsage: make <target> "\
		 "[one or more targets separated by spaces and in the order that their would executed]\n\n"\
		 "The following targets are available: \n"
	@sed -e '/#\{2\}@/!d; s/\\$$//; s/:[^#\t]*/\n\t\t\t/; s/^/\t/; s/#\{2\}@ *//' $(MAKEFILE_LIST)
	@echo "\n"
endef

# Packages installed in the virtualenv place their commands in the bin directory inside virtualenv path.
VENV_PATH=${VIRTUAL_ENV}/bin
# preffix all the commands with the virtualenv bin path
ANSIBLE_PLAYBBOK = ${VENV_PATH}/ansible-playbook
ANSIBLE_GALAXY = ${VENV_PATH}/ansible-galaxy
PIP = ${VENV_PATH}/pip

.PHONY: help
help: ##@ Show this help.
	@$(usage)

.PHONY: all
all: init up play ##@ Run init, up, and play targets.

# Install ansible and python dependecies
.PHONY: init
init: pip-install galaxy-up ##@ Run pip-install, and galaxy-up targets.

.PHONY: pip-install
pip-install: ##@ Install python dependecies using pip.
	${PIP} install --requirement requirements.txt

.PHONY: pip-upgrade
pip-upgrade: ##@ Upgrade python dependecies using pip. This ignore pinning versions in requirements.txt.
	${PIP} install --upgrade $(shell sed -e '/^[a-zA-Z0-9\._-]/!d; s/=.*$$//' requirements.txt)

.PHONY: pip-freeze
pip-freeze: ##@ Like pip freeze but only for packages that are in requirements.txt. This doesn't include any package that could be present in the virtualenv as result of manual installs or resolved dependencies.
	REQ="$(shell ${PIP} freeze --quiet --requirement requirements.txt | sed '/^## The following requirements were added by pip freeze:$$/,$$ d')";\
	echo $$REQ | sed 's/ /\n/g' > requirements.txt

.PHONY: pip-uninstall
pip-uninstall: ##@ Uninstall python dependencies using pip.
	${PIP}  pip uninstall --yes --requirement requirements.txt

.PHONY: up
up: Vagrantfile ##@ Deploy Vagrant boxes.
	vagrant box update
	vagrant up

galaxy-up: ansible-requirements.yml ##@ Install ansible modules using ansible-galaxy.
	${ANSIBLE_GALAXY} collection install --requirement ansible-requirements.yml

.PHONY: play
play: galaxy-up ##@ Run ansible-playbook.
	${ANSIBLE_PLAYBBOK} playbook.yml

.PHONY: debug
debug: galaxy-up ##@ Run ansible-playbook, running only plays and tasks tagged with 'debug'.
	${ANSIBLE_PLAYBBOK} playbook.yml --tags debug

.PHONY: destroy
destroy: ##@ Destroy Vagrant boxes.
	vagrant destroy --force

.PHONY: build
build: up play ##@ Run up, and play targets.

.PHONY: rebuild
rebuild: destroy up play ##@ Run destroy, up, and play targets.
