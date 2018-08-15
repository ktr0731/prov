#!/usr/bin/env bash

verbose='-vv'

set -e

# install Homebrew
if [[ -z $(command -v brew) ]]; then
  echo -n "===> installing Homebrew... "
  yes "" | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "done!"
fi

if [[ -z $(command -v ansible-playbook) ]]; then
  echo -n "===> installing Ansible... "
  brew install ansible
  echo "done!"
fi

echo "===> execute Ansible Playbook... "
ansible-playbook "$verbose" site.yml
