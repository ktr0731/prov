require "yaml"

BREW_INSTALL = 'yes "" | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'

brew = YAML.load_file("./packages/brew.yml")

execute "Install Homebrew" do
  command BREW_INSTALL
  not_if "which brew > /dev/null"
end

ENV["HOMEBREW_CASK_OPTS"] = "--appdir=/Applications"
brew["cask"].each do |pkg|
  execute "brew cask install #{pkg}"
end

execute "Install dotfiles" do
  command "git clone https://github.com/lycoris0731/dotfiles && cd ~/dotfiles && make all"
  not_if "test -d ~/dotfiles"
end

execute "Install GHQ" do
  command "go get github.com/motemen/ghq"
  not_if "test -z $GOPATH/bin/ghq"
end

execute "Install GHQ packages" do
  command "ghq import < ./packages/ghq.txt"
end

# TODO: Java <- sbt の依存関係を解消したい
brew["brew"].each do |pkg|
  execute "brew install #{pkg}"
end

execute "Install pip3 packages" do
  command "pip3 install --require ./packages/pip3.txt"
end
