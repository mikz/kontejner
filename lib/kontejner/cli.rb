require 'thor'
require 'kontejner'

module Kontejner
  class CLI < Thor
    desc 'start', 'start kontejner dns server'

    method_option :port, default: 53, type: :numeric
    method_option :address, default: '0.0.0.0', type: :string

    method_option :domain, required: true, type: :string
    method_option :docker, required: true, default: Docker.default_socket_url, type: :string
    method_option :ttl, require: true, type: :numeric, default: 60

    def start
      server = Kontejner::Server.new(dns_options)
      server.start(server_options)
    end

    private

    def dns_options
      { domain: options[:domain], docker: options[:docker], ttl: options[:ttl] }
    end

    def server_options
      address = options[:address]
      port = options[:port]

      { listen: [[:tcp, address, port], [:udp, address, port]] }
    end
  end
end
