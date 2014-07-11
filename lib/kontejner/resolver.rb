require 'docker'
require 'active_support/cache'

module Kontejner
  class Resolver
    def initialize(docker:)
      @connection = Docker::Connection.new(docker, {})
      @cache = ActiveSupport::Cache::MemoryStore.new
    end

    def resolve(name)
      @cache.fetch(name, expires_in: 60) { fetch(name) }
    rescue Docker::Error::NotFoundError
    end

    def fetch(name)
      container = Docker::Container.get(name, {}, @connection)
      container.json['NetworkSettings']['IPAddress']
    end
  end
end
