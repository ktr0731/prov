SHELL := /bin/bash

# brew and cask tasks re-generate brew.yml with installed packages

.PHONY: brew
brew: 
	brew list -1 --full-name | xargs ./scripts/brew -brew packages/brew.yml

.PHONY: cask
cask:
	brew cask list -1 --full-name | xargs ./scripts/brew -cask packages/brew.yml
