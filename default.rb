require "yaml"

BREW_INSTALL = 'yes "" | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'

conf = YAML.load_file("./packages.yml")

execute "Install Homebrew" do
  command BREW_INSTALL
  not_if "which brew > /dev/null"
end

ENV["HOMEBREW_CASK_OPTS"] = "--appdir=/Applications"
conf["cask"].each do |pkg|
  execute "brew cask install #{pkg}"
end

# TODO: Java <- sbt の依存関係を解消したい
conf["brew"].each do |pkg|
  package pkg
end
