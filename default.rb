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

execute "Install GHQ" do
  command "go get github.com/motemen/ghq"
  not_if "test -z $GOPATH/bin/ghq"
end

execute "Install GHQ packages" do
  command "ghq import < ./packages/ghq.txt"
end

brew["brew"].each do |pkg|
  execute "brew install #{pkg}"
end

execute "Install pip3 packages" do
  command "pip3 install --require ./packages/pip3.txt"
end

execute "Install protoc" do
  command "curl -sLo /tmp/protoc.zip https://github.com/google/protobuf/releases/download/v3.6.0/protoc-3.6.0-osx-x86_64.zip && unzip /tmp/protoc.zip -d /tmp/protoc &&
  mv /tmp/protoc/bin/protoc /usr/local/bin/protoc &&
  rm -rf /tmp/proto /tmp/protoc.zip"
  not_if "which protoc > /dev/null"
end
