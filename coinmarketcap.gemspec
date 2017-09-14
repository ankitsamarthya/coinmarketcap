# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "coinmarketcap/version"

Gem::Specification.new do |spec|
  spec.name          = "coinmarketcap"
  spec.version       = Coinmarketcap::VERSION
  spec.authors       = ["Ankit Samarthya"]
  spec.email         = ["ankitsamar@outlook.com"]

  spec.summary       = %q{Coinmarketcap.com API ruby wrapper}
  spec.description   = %q{Get all the coins listed on coinmarketcap.com}
  spec.homepage      = "https://github.com/ankitsamarthya/coinmarketcap"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'httparty'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-coolline'
end
