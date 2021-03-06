require 'rubydns'
require 'kontejner/resolver'

module Kontejner
  class Server
    GOOGLE_SERVERS = [ [:udp, '8.8.8.8', 53], [:tcp, '8.8.8.8', 53], [:udp, '8.8.4.4', 53], [:tcp, '8.8.4.4', 53] ]

    IN = Resolv::DNS::Resource::IN

    def initialize(domain:,docker:,ttl:)
      @dns = RubyDNS::RuleBasedServer.new

      @logger = @dns.logger
      @logger.level = Logger::DEBUG

      @matcher = /(?<subdomain>[^.]+)\.#{domain}$/
      @ttl = ttl

      @upstream = RubyDNS::Resolver.new(GOOGLE_SERVERS)
      @docker = Kontejner::Resolver.new(docker: docker)

      @logger.info("Docker Connection #{docker}")
    end

    def start(**options)
      @logger.debug("Matching #{@matcher}")

      @dns.match(@matcher, IN::A) do |t, match|
        ip = @docker.resolve(match[:subdomain])

        if ip
          t.respond!(ip, ttl: @ttl)
        else
          t.fail! :NXDomain
        end
      end

      @dns.otherwise do |q|
        q.passthrough!(@upstream)
      end

      run(options)
    end

    def run(options)
      EventMachine.run do
        trap("INT") do
          EventMachine.stop
        end

        @dns.run(options)
      end

      @dns.fire(:stop)
    end
  end
end
