# frozen_string_literal: true

require_relative 'lib/mutt/ldap/query/version'

Gem::Specification.new do |spec|
  spec.name          = 'mutt-ldap-query'
  spec.version       = Mutt::Ldap::Query::VERSION
  spec.authors       = ['Romain Tartière']
  spec.email         = ['romain@blogreen.org']

  spec.summary       = 'Search LDAP directory from mutt'
  spec.homepage      = 'https://github.com/smortex/mutt-ldap-query'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/smortex/mutt-ldap-query'
  spec.metadata['changelog_uri'] = 'https://github.com/smortex/mutt-ldap-query/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'net-ldap', '~> 0.17'
  spec.add_dependency 'xdg', '>= 4.0'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
