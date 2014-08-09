require 'docker'
require 'active_support/cache'
require 'monitor'
require 'logger'

module Kontejner
  class Resolver
    include MonitorMixin

    CACHE_TTL = 600
    CACHE_OPTIONS = { ttl: CACHE_TTL, race_condition_ttl: CACHE_TTL/100 }.freeze

    def initialize(docker:)
      @logger = Logger.new($stdout)

      @connection = ::Docker::Connection.new(docker, {})
      @id_cache = ::ActiveSupport::Cache::MemoryStore.new
      @ip_cache = ::ActiveSupport::Cache::MemoryStore.new

      super()

      @updater = Thread.new do
        loop do
          listen_event_stream
        end
      end
    end

    def listen_event_stream
      ::Docker::Event.stream({}, @connection) do |event|
        handle_event(event)
      end
    rescue
      @logger.error('EvenStream') { $ERROR_INFO }
    end

    def handle_event(event)
      @logger.debug("Processing event #{event}")

      case event.status
        when 'die'.freeze
          @id_cache.clear
          @ip_cache.delete(event.id)
        when 'start'.freeze
          @id_cache.clear
          @ip_cache.write(event.id, ip(event.id))
        when 'create'.freeze
      end
    end

    def resolve(name)
      id = id(name)

      @logger.debug("#{name} has id #{id}")
      @ip_cache.fetch(id, CACHE_OPTIONS) do
        ip(id)
      end
    rescue Docker::Error::NotFoundError
      @logger.warn("#{name} could not be found")
      false
    end

    def id(name)
      case name.length
        when 64
          name
        else
          @id_cache.fetch(name, CACHE_OPTIONS) do
            container = Docker::Container.get(name, {}, @connection)
            @logger.debug("Resolved #{name} to #{container.id}")
            container.id
          end
      end
    end

    def ip(id)
      container = Docker::Container.get(id, {}, @connection)
      json = container.json
      unless json['State']['Running']
        @logger.warn("#{id} is not running")
        raise Docker::Error::NotFoundError
      end
      ip = json['NetworkSettings']['IPAddress']
      @logger.debug("#{id} has ip #{ip}")
      ip
    end

    private
  end
end
