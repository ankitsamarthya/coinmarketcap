
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coinmarketcap/version'

Gem::Specification.new do |spec|
  spec.name          = 'coinmarketcap'
  spec.version       = Coinmarketcap::VERSION
  spec.authors       = ['Kurt Smith']
  spec.email         = ['zippydev@protonmail.com']

  spec.summary       = 'Coinmarketcap.com API ruby wrapper'
  spec.description   = 'Get all the coins listed on coinmarketcap.com'
  spec.homepage      = 'https://github.com/kurt-smith/coinmarketcap'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'http',           '~> 3.0'
  spec.add_runtime_dependency 'nokogiri',       '~> 1.8'
  spec.add_development_dependency 'bundler',    '~> 1.14'
  spec.add_development_dependency 'coveralls',  '~> 0.8'
  spec.add_development_dependency 'pry',        '~> 0.11'
  spec.add_development_dependency 'rake',       '~> 10.0'
  spec.add_development_dependency 'rspec',      '~> 3.7'
  spec.add_development_dependency 'vcr',        '~> 4.0'
  spec.add_development_dependency 'webmock',    '~> 3.2'
end
