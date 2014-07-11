require 'kontejner/version'
require 'docker'

module Kontejner
  autoload :CLI, 'kontejner/cli'
  autoload :Server, 'kontejner/server'
  autoload :Resolver, 'kontejner/resolver'
end
