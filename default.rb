require "yaml"

conf = YAML.load_file("./brew.yml")
conf["packages"].each do |pkg|
  package pkg
end
