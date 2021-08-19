# frozen_string_literal: true

require 'fileutils'
require 'net-ldap'
require 'xdg'
require 'yaml'

module Mutt
  module Ldap
    module Query
      class Worker
        attr_reader :query

        def initialize(query)
          @query = query
        end

        def config_path
          @xdg ||= XDG::Environment.new
          File.join(@xdg.config_home, 'mutt-ldap-query', 'config.yml')
        end

        def configured?
          File.exist?(config_path)
        end

        def config
          @config ||= YAML.load_file(config_path)
        end

        def search
          result = []

          ldap = Net::LDAP.new(config)
          ldap.search(attributes: search_attributes, filter: search_filter) do |entry|
            mail_attributes.map { |x| entry[x] }.flatten.each do |mail|
              result << "#{mail}\t#{entry['cn'].first}\t#{entry['description'].first}"
            end
          end

          result
        end

        def search_attributes
          %w[cn mail mailAlternateAddress description]
        end

        def search_filter
          res = Net::LDAP::Filter.eq('objectClass', 'person')
          res &= query.map { |q| search_attributes.map { |a| Net::LDAP::Filter.contains(a, q) } }.flatten.inject(:|) if query.any?
          res
        end

        def mail_attributes
          %w[mail mailAlternateAddress]
        end

        def gen_config
          raise "#{config_path} already exist." if configured?

          FileUtils.mkdir_p(File.dirname(config_path))
          File.write(config_path, sample_config, perm: 0o600)
        end

        def edit_config
          system("${EDITOR:-vi} #{config_path}")
        end

        def sample_config
          <<~CONFIG
            :host: ldap.example.com
            :port: 389
            :base: ou=people,dc=example,dc=com
            :auth:
              :method: :simple
              :username: cn=mutt-ldap-query,ou=services,dc=example,dc=com
              :password: secret
            :encryption:
              :method: :start_tls
          CONFIG
        end
      end
    end
  end
end
