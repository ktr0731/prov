require "yaml"

BREW_INSTALL = "/usr/bin/ruby -e $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

conf = YAML.load_file("./packages.yml")

execute BREW_INSTALL do
  not_if "which brew > /dev/null"
end

conf["brew"].each do |pkg|
  package pkg
end

ENV["HOMEBREW_CASK_OPTS"] = "--appdir=/Applications"
conf["cask"].each do |pkg|
  execute "brew cask install #{pkg}"
end
